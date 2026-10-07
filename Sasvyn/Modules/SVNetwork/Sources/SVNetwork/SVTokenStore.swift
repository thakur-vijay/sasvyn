//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation
import NetworkKit
import Security

public final class SVTokenStore: TokenStore, AppleLoginStoring, ClientIDStoring{

    fileprivate enum Key {
        static let userId = "com.vijaythakur.sasvyn.userId"
        static let accessToken = "com.vijaythakur.sasvyn.accessToken"
        static let refreshToken = "com.vijaythakur.sasvyn.refreshToken"
        static let appleLoginResult = "com.vijaythakur.sasvyn.appleLoginResult"
        static let clientID = "com.vijaythakur.sasvyn.clientId"
    }

    public init() {}

    public var accessToken: String? {
        read(key: Key.accessToken)
    }

    public var refreshToken: String? {
        read(key: Key.refreshToken)
    }

    public var userId: String? {
        read(key: Key.userId)
    }

    public func store(
        accessToken: String,
        refreshToken: String
    ) {
        save(accessToken, key: Key.accessToken)
        save(refreshToken, key: Key.refreshToken)
    }

    public func save(userId: String) {
        save(userId, key: Key.userId)
    }

    public func clearTokens() {
        delete(key: Key.accessToken)
        delete(key: Key.refreshToken)
    }

    // MARK: - Private

    fileprivate func save(
        _ value: String,
        key: String
    ) {
        let data = Data(value.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String:
                kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )

        if status == errSecDuplicateItem {
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key
            ]

            let attributes: [String: Any] = [
                kSecValueData as String: data
            ]

            SecItemUpdate(
                updateQuery as CFDictionary,
                attributes as CFDictionary
            )
        }
    }

    fileprivate func read(
        key: String
    ) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: CFTypeRef?

        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )

        guard status == errSecSuccess,
              let data = result as? Data else {
            return nil
        }

        return String(
            data: data,
            encoding: .utf8
        )
    }

    fileprivate func delete(
        key: String
    ) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(
            query as CFDictionary
        )
    }
}

// MARK: - Apple Login

public protocol AppleLoginStoring: AnyObject, Sendable{

    func saveAppleLoginResult(
        _ result: AppleLoginResult
    )

    func appleLoginResult()throws -> AppleLoginResult

    func clearAppleLoginResult()
}

public extension AppleLoginStoring where Self: SVTokenStore {

    func saveAppleLoginResult(
        _ result: AppleLoginResult
    ) {
        guard let data = try? JSONEncoder().encode(result),
              let value = String(data: data, encoding: .utf8)
        else {
            return
        }

        save(
            value,
            key: Key.appleLoginResult
        )
    }

    func appleLoginResult() throws -> AppleLoginResult {
        guard let value = read(
            key: Key.appleLoginResult
        ),
        let data = value.data(using: .utf8)
        else {
            throw AppleLoginError.dataNotFound
        }

        return try JSONDecoder().decode(
            AppleLoginResult.self,
            from: data
        )
    }

    func clearAppleLoginResult() {
        delete(
            key: Key.appleLoginResult
        )
    }
}

public enum AppleLoginError: Error {
    case dataNotFound
}

// MARK: - Apple Login Result

public struct AppleLoginResult: Codable, Sendable {

    public let appleId: String
    public let email: String?
    public let fullName: String?

    public init(
        appleId: String,
        email: String?,
        fullName: String?
    ) {
        self.appleId = appleId
        self.email = email
        self.fullName = fullName
    }
}

public protocol ClientIDStoring: AnyObject, Sendable{

    func saveClientID(
        _ id: String
    )

    var clientID: String? { get }

    func clearClientID()
}

public extension ClientIDStoring where Self: SVTokenStore {
     
    func saveClientID(_ id: String) {
        save(id, key: Key.clientID)
    }
    
    var clientID: String? {
        read(key: Key.clientID)
    }
    
    func clearClientID() {
        delete(key: Key.clientID)
    }
}

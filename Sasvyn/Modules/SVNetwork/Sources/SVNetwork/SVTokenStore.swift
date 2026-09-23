//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation
import NetworkKit
import Security

public final class SVTokenStore: TokenStore{

    private enum Key {
        static let userId = "com.vijaythakur.sasvyn.userId"
        static let accessToken = "com.vijaythakur.sasvyn.accessToken"
        static let refreshToken = "com.vijaythakur.sasvyn.refreshToken"
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

    private func save(
        _ value: String,
        key: String
    ) {
        let data = Data(value.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
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

    private func read(
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

    private func delete(
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

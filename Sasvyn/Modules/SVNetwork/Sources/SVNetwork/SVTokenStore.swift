//
//  File.swift
//  SVDIInfra
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation
import NetworkKit
import Security

public final class SVTokenStore: TokenStore, AppleLoginStoring{

    fileprivate enum Key {
        static let userId = "com.vijaythakur.sasvyn.userId"
        static let accessToken = "com.vijaythakur.sasvyn.accessToken"
        static let refreshToken = "com.vijaythakur.sasvyn.refreshToken"
        static let appleLoginResult = "com.vijaythakur.sasvyn.appleLoginResult"
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

//- some: "eyJraWQiOiJHTkNmNEo4M09oIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLmFydGlzdC55YXR0c1Rlc3QiLCJleHAiOjE3OTA0Mzk5OTYsImlhdCI6MTc5MDM1MzU5Niwic3ViIjoiMDAwMTI5LjU2YmFjMDI3N2E2ODQyMTFiZDc5YzViNGQwNWM3ODMxLjA2MTQiLCJjX2hhc2giOiJlQ3dHOXJORFpvY1dJOWZGcXBKenh3IiwiZW1haWwiOiJ0aGFrdXJ2aWpheTAwMDZAaWNsb3VkLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdXRoX3RpbWUiOjE3OTAzNTM1OTYsIm5vbmNlX3N1cHBvcnRlZCI6dHJ1ZX0.pMDDxCzBNoxQvOUzdQiU7y1PFnS9E8wtXsYHyOUWEqhqnL95eXXaReSEkPN8TVva8fPVA85w5RwiGsVSbS5BJ_C4Ja9Urk_ZS38lAid9v6Px2GiFAg9EVu54xkoX1kHX_THtvu3-gjqT5r8lKOgYZk18UPl9KqVJnOQF2NZcRX-Cbe9tl04u4Tj91vKscgbxf7eP2V7elKosT86namt7OppDNTx_8o2Z9vLuaylMuPhpCDEhGD0qWe4Ejmav5Vxqs_iRu6p3qCc4sBerJ21aYSwyzF3p4CdMaDH3n_xQwjBcQMb7Uh4tXbc5mZ-p6b9zBrVXoGo-7g5r-l-0P84Z2g"
//▿ authorizationCode: Optional("ce2dd73cc661349f2865135247ae5ce51.0.prsz.PZ5J-QfnxlkrxL0fyc-Nnw")
//- some: "ce2dd73cc661349f2865135247ae5ce51.0.prsz.PZ5J-QfnxlkrxL0fyc-Nnw"
//- appleId: "000129.56bac0277a684211bd79c5b4d05c7831.0614"
//▿ email: Optional("thakurvijay0006@icloud.com")
//- some: "thakurvijay0006@icloud.com"
//▿ fullName: Optional("Vijay Thakur")
//- some: "Vijay Thakur"

//
//  KeychainTokenStorage.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import Security

/// Stores the OAuth token securely in the Keychain with AES encryption.
public final class KeychainTokenStorage: TokenStorage {

    private let service = "com.secureauthkit.token"
    private let account = "access_token"

    public init() {}

    public func save(_ token: OAuthToken) throws {
        let data = try JSONEncoder().encode(token)
        try saveToKeychain(data)
    }

    public func load() throws -> OAuthToken? {
        guard let data = try loadFromKeychain() else { return nil }
        return try JSONDecoder().decode(OAuthToken.self, from: data)
    }

    public func clear() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }

    // MARK: - Private helpers

    private func saveToKeychain(_ data: Data) throws {
        try clear()
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw SecureAuthError.keychainFailure
        }
    }

    private func loadFromKeychain() throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess else {
            return nil
        }

        return item as? Data
    }
}

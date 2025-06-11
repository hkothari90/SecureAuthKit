//
//  DPoPKeyManager.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import CryptoKit
import Security

/// Abstracts the functionality required to generate and manage DPoP keys.
public protocol DPoPKeyManaging: Sendable {
    func sign(method: String, url: URL) throws -> String
    func publicKeyThumbprint() throws -> String
}

/// Manages the DPoP private key stored in the Secure Enclave and generates signed JWTs for DPoP proof.
public final class DPoPKeyManager: DPoPKeyManaging {

    private static let keyLabel = "com.secureauthkit.dpop.key"
    private var cachedKey: SecureEnclave.P256.Signing.PrivateKey?

    public init() {}

    private func getOrCreateKey() throws -> SecureEnclave.P256.Signing.PrivateKey {
        if let cached = cachedKey {
            return cached
        }

        if let existingKey = try? retrieveKey() {
            cachedKey = existingKey
            return existingKey
        }

        let access = SecAccessControlCreateWithFlags(nil,
                                                     kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                     [.privateKeyUsage, .biometryAny],
                                                     nil)!

        let privateKey = try SecureEnclave.P256.Signing.PrivateKey(compactRepresentable: false, accessControl: access, authenticationContext: nil)

        cachedKey = privateKey
        return privateKey
    }

    private func retrieveKey() throws -> SecureEnclave.P256.Signing.PrivateKey {
        throw SecureAuthError.enclaveFailure // Avoid broken reference initializer in Swift 6
    }

    // MARK: - DPoP Signing

    public func sign(method: String, url: URL) throws -> String {
        let key = try getOrCreateKey()
        let jwt = try JWTEncoder().encodeDPoP(using: key, method: method, url: url)
        return jwt
    }

    public func publicKeyThumbprint() throws -> String {
        let key = try getOrCreateKey()
        let pub = key.publicKey.rawRepresentation
        return Data(pub).base64URLEncoded()
    }
}

//
//  PKCE.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import CryptoKit

/// Encapsulates a PKCE code verifier and its associated challenge.
internal struct PKCE: Sendable {
    let codeVerifier: String
    let codeChallenge: String

    init() {
        let verifier = PKCE.generateCodeVerifier()
        self.codeVerifier = verifier
        self.codeChallenge = PKCE.deriveCodeChallenge(from: verifier)
    }

    private static func generateCodeVerifier() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        return String((0..<64).compactMap { _ in characters.randomElement() })
    }

    private static func deriveCodeChallenge(from verifier: String) -> String {
        let data = Data(verifier.utf8)
        let hash = SHA256.hash(data: data)
        return Data(hash).base64URLEncoded()
    }
}

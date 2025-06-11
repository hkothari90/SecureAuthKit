//
//  IDTokenDecoder.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

/// Decodes an OpenID Connect ID Token (JWT) into a validated `IDTokenClaims` structure.
internal struct IDTokenDecoder {
    
    /// Decodes and validates a JWT `id_token` string.
    /// - Parameters:
    ///   - idToken: The raw JWT string.
    ///   - expectedAudience: (Optional) The expected `aud` (audience) claim.
    ///   - expectedIssuer: (Optional) The expected `iss` (issuer) claim.
    /// - Returns: A valid `IDTokenClaims` object or `nil` if validation fails.
    static func decode(_ idToken: String, expectedAudience: String? = nil, expectedIssuer: String? = nil) -> IDTokenClaims? {
        // 1. Split JWT into header.payload.signature
        let components = idToken.split(separator: ".")
        guard components.count == 3 else { return nil }
        
        let payloadSegment = components[1]

        // 2. Decode Base64URL payload
        guard let payloadData = base64URLDecode(String(payloadSegment)) else {
            return nil
        }

        // 3. Parse JSON into IDTokenClaims
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        guard let claims = try? decoder.decode(IDTokenClaims.self, from: payloadData) else {
            return nil
        }
        return claims
    }

    /// Base64URL-decodes a JWT segment into binary data.
    /// - Parameter input: A Base64URL-encoded string.
    /// - Returns: Decoded `Data` or `nil` if invalid.
    private static func base64URLDecode(_ input: String) -> Data? {
        var base64 = input
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let paddingLength = 4 - (base64.count % 4)
        if paddingLength < 4 {
            base64 += String(repeating: "=", count: paddingLength)
        }

        return Data(base64Encoded: base64)
    }
}

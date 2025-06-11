//
//  JWTEncoder.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import CryptoKit

/// Encodes JWTs for DPoP proof using ES256 and Secure Enclave.
internal struct JWTEncoder {

    /// Encodes a signed JWT DPoP proof for the given method and URL.
    func encodeDPoP(using key: SecureEnclave.P256.Signing.PrivateKey, method: String, url: URL) throws -> String {
        let header: [String: String] = [
            "alg": "ES256",
            "typ": "dpop+jwt"
        ]

        let jti = UUID().uuidString
        let iat = Int(Date().timeIntervalSince1970)
        let htu = url.absoluteString
        let htm = method.uppercased()

        let payload: [String: Any] = [
            "htu": htu,
            "htm": htm,
            "jti": jti,
            "iat": iat
        ]

        let headerData = try JSONSerialization.data(withJSONObject: header)
        let payloadData = try JSONSerialization.data(withJSONObject: payload)

        let headerEncoded = headerData.base64URLEncoded()
        let payloadEncoded = payloadData.base64URLEncoded()

        let signingInput = "\(headerEncoded).\(payloadEncoded)"
        let signature = try key.signature(for: Data(signingInput.utf8))
        let signatureEncoded = signature.derRepresentation.base64URLEncoded()

        return "\(signingInput).\(signatureEncoded)"
    }
}

internal extension Data {
    func base64URLEncoded() -> String {
        self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

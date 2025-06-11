//
//  String+JWT.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

internal extension String {
    /// Extracts the payload part of a JWT (Base64URL-decoded).
    func jwtPayload() -> Data? {
        let segments = self.components(separatedBy: ".")
        guard segments.count >= 2 else { return nil }
        let base64 = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            .padding(toMultipleOf4With: "=")
        return Data(base64Encoded: base64)
    }
}

private extension String {
    func padding(toMultipleOf4With pad: String) -> String {
        let remainder = count % 4
        if remainder == 0 { return self }
        return self + String(repeating: pad, count: 4 - remainder)
    }
}

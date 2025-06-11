//
//  IDTokenClaims+Mock.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import SecureAuthKit

public extension IDTokenClaims {
    static let mock = IDTokenClaims(
        iss: "https://auth.example.com",
        sub: "1234567890",
        aud: ["com.example.app"],
        exp: Date(),
        iat: Date(),
        name: "Hardik Kothari",
        preferredUsername: "hkothari90",
        email: "hardik.kothari90@gmail.com",
        emailVerified: true
    )
    
    static var mockJWT: String {
        let payload = try! JSONEncoder().encode(mock)
        let base64 = payload.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return "header.\(base64).signature"
    }
}

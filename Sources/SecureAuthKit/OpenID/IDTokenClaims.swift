//
//  IDTokenClaims.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

/// Represents the standard OpenID Connect claims inside an ID Token (JWT).
public struct IDTokenClaims: Codable, Sendable, Equatable {
    
    /// Issuer Identifier for the Issuer of the response.
    public let iss: String?
    
    /// Subject Identifier. A unique identifier for the authenticated user.
    public let sub: String?
    
    /// Audience(s) that this ID Token is intended for.
    public let aud: [String]?
    
    /// Expiration time on or after which the ID Token MUST NOT be accepted for processing.
    public let exp: Date?
    
    /// Time at which the JWT was issued.
    public let iat: Date?
    
    /// Name of the user (if provided by the provider).
    public let name: String?
    
    /// Preferred username or handle.
    public let preferredUsername: String?
    
    /// Email address of the user (if available).
    public let email: String?
    
    /// Whether the email is verified.
    public let emailVerified: Bool?

    /// Initializes an IDTokenClaims instance (primarily used for testing).
    public init(
        iss: String? = nil,
        sub: String? = nil,
        aud: [String]? = nil,
        exp: Date? = nil,
        iat: Date? = nil,
        name: String? = nil,
        preferredUsername: String? = nil,
        email: String? = nil,
        emailVerified: Bool? = nil
    ) {
        self.iss = iss
        self.sub = sub
        self.aud = aud
        self.exp = exp
        self.iat = iat
        self.name = name
        self.preferredUsername = preferredUsername
        self.email = email
        self.emailVerified = emailVerified
    }
}

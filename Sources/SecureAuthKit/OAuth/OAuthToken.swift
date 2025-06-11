//
//  OAuthToken.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

/// Represents an OAuth 2.0 token response.
public struct OAuthToken: Codable, Sendable, Equatable {
    public let accessToken: String
    public let tokenType: String
    public let expiresIn: TimeInterval?
    public let refreshToken: String?
    public let scope: String?
    public let idToken: String?
    public let createdAt: Date

    /// Lazily decoded claims from `idToken` (OpenID Connect).
    public var idTokenClaims: IDTokenClaims? {
        guard let idToken else { return nil }
        return IDTokenDecoder.decode(idToken)
    }

    public init(
        accessToken: String,
        tokenType: String,
        expiresIn: TimeInterval?,
        refreshToken: String?,
        scope: String?,
        idToken: String?,
        createdAt: Date = Date()
    ) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
        self.scope = scope
        self.idToken = idToken
        self.createdAt = createdAt
    }

    /// Returns true if the access token has expired.
    public var isExpired: Bool {
        guard let expiresIn else { return false }
        return Date() > createdAt.addingTimeInterval(expiresIn - 30) // buffer
    }

    /// Returns true if the token has a refresh token.
    public var canRefresh: Bool {
        refreshToken != nil
    }
}

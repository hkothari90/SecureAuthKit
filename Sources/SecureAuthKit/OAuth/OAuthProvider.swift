//
//  OAuthProvider.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

/// Abstraction for handling OAuth2 operations.
/// Implementations may support multiple grant types and strategies (e.g., PKCE, refresh).
public protocol OAuthProvider: Sendable {

    /// Performs login using Resource Owner Password Credentials (ROPC).
    /// Only used in trusted or legacy scenarios.
    /// - Parameters:
    ///   - username: Username/email/identifier.
    ///   - password: Cleartext password.
    /// - Returns: An OAuthToken on success.
    func login(username: String, password: String) async throws -> OAuthToken

    /// Performs login using Authorization Code Flow via ASWebAuthenticationSession.
    /// PKCE is internally managed by the implementation.
    /// - Returns: OAuthToken if successful.
    func loginWithBrowser() async throws -> OAuthToken

    /// Attempts to refresh a previously issued OAuthToken using the refresh token grant.
    /// - Parameter token: Previous token to refresh.
    /// - Returns: Updated token.
    func refresh(token: OAuthToken) async throws -> OAuthToken

    /// Performs optional logout. Backend support required.
    func logout() async throws
}

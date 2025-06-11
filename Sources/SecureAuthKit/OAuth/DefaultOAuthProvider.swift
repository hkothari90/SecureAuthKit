//
//  DefaultOAuthProvider.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

/// Default implementation of OAuthProvider using OAuth 2.0 Authorization Code Flow with PKCE and Refresh Tokens.
public final class DefaultOAuthProvider: NSObject, OAuthProvider {

    // MARK: - Dependencies

    private let clientID: String
    private let authEndpoint: URL
    private let tokenEndpoint: URL
    private let redirectURI: URL
    private let dpop: DPoPKeyManaging

    // MARK: - Init

    public init(clientID: String, authEndpoint: URL, tokenEndpoint: URL, redirectURI: URL, dpop: DPoPKeyManaging) {
        self.clientID = clientID
        self.authEndpoint = authEndpoint
        self.tokenEndpoint = tokenEndpoint
        self.redirectURI = redirectURI
        self.dpop = dpop
    }

    // MARK: - Login with Credentials (ROPC)

    public func login(username: String, password: String) async throws -> OAuthToken {
        var request = URLRequest(url: tokenEndpoint)
        request.httpMethod = "POST"

        let body = [
            "grant_type": "password",
            "client_id": clientID,
            "username": username,
            "password": password
        ]

        request.httpBody = body.percentEncoded
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.setValue(
            try dpop.sign(method: "POST", url: request.url!),
            forHTTPHeaderField: "DPoP"
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(OAuthToken.self, from: data)
    }

    // MARK: - Login with Browser (PKCE + Auth Code)

    public func loginWithBrowser() async throws -> OAuthToken {
        let pkce = PKCE()
        let handler = await AuthorizationCodeFlowHandler(
            clientID: clientID,
            authEndpoint: authEndpoint,
            tokenEndpoint: tokenEndpoint,
            redirectURI: redirectURI,
            pkce: pkce,
            dpop: dpop
        )
        return try await handler.authorize()
    }

    // MARK: - Refresh Token

    public func refresh(token: OAuthToken) async throws -> OAuthToken {
        guard let refresh = token.refreshToken else {
            throw SecureAuthError.missingRefreshToken
        }

        var request = URLRequest(url: tokenEndpoint)
        request.httpMethod = "POST"

        let body = [
            "grant_type": "refresh_token",
            "client_id": clientID,
            "refresh_token": refresh
        ]

        request.httpBody = body.percentEncoded
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.setValue(
            try dpop.sign(method: "POST", url: request.url!),
            forHTTPHeaderField: "DPoP"
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(OAuthToken.self, from: data)
    }

    // MARK: - Logout

    public func logout() async throws {
        var request = URLRequest(url: authEndpoint.appendingPathComponent("/logout"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add DPoP proof if required
        request.setValue(
            try dpop.sign(method: "POST", url: request.url!),
            forHTTPHeaderField: "DPoP"
        )

        _ = try await URLSession.shared.data(for: request)
    }
}

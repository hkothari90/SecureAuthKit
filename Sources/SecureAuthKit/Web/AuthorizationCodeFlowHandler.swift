//
//  AuthorizationCodeFlowHandler.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import AuthenticationServices

/// Handles the OAuth2 Authorization Code flow using ASWebAuthenticationSession.
internal final class AuthorizationCodeFlowHandler: NSObject, ASWebAuthenticationPresentationContextProviding {

    // MARK: - Properties
    private let clientID: String
    private let authEndpoint: URL
    private let tokenEndpoint: URL
    private let redirectURI: URL
    private let pkce: PKCE
    private let dpop: DPoPKeyManaging

    // MARK: - Init
    init(clientID: String,
                authEndpoint: URL,
                tokenEndpoint: URL,
                redirectURI: URL,
                pkce: PKCE,
                dpop: DPoPKeyManaging) {
        self.clientID = clientID
        self.authEndpoint = authEndpoint
        self.tokenEndpoint = tokenEndpoint
        self.redirectURI = redirectURI
        self.pkce = pkce
        self.dpop = dpop
    }

    // MARK: - OAuth Flow
    public func authorize() async throws -> OAuthToken {
        let url = authorizationURL()

        let callbackURL: URL = try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: redirectURI.scheme) { callbackURL, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let callbackURL = callbackURL {
                    continuation.resume(returning: callbackURL)
                } else {
                    continuation.resume(throwing: SecureAuthError.invalidCallback)
                }
            }
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }

        guard let code = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "code" })?.value else {
            throw SecureAuthError.invalidCallback
        }

        return try await exchangeCodeForToken(code: code)
    }

    private func authorizationURL() -> URL {
        var components = URLComponents(url: authEndpoint, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI.absoluteString),
            URLQueryItem(name: "code_challenge", value: pkce.codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256")
        ]
        return components.url!
    }

    private func exchangeCodeForToken(code: String) async throws -> OAuthToken {
        var request = URLRequest(url: tokenEndpoint)
        request.httpMethod = "POST"

        let body = [
            "grant_type": "authorization_code",
            "client_id": clientID,
            "code": code,
            "redirect_uri": redirectURI.absoluteString,
            "code_verifier": pkce.codeVerifier
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

    // MARK: - ASWebAuthenticationPresentationContextProviding
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}

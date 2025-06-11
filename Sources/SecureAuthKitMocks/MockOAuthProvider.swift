//
//  MockOAuthProvider.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import SecureAuthKit

/// A mock implementation of OAuthProvider for testing authentication flows.
public final class MockOAuthProvider: OAuthProvider, @unchecked Sendable {

    public let loginToken: OAuthToken
    public let refreshedToken: OAuthToken
    public private(set) var didLogout = false

    public init(
        loginToken: OAuthToken = .mockToken,
        refreshedToken: OAuthToken = .mockToken
    ) {
        self.loginToken = loginToken
        self.refreshedToken = refreshedToken
    }

    public func login(username: String, password: String) async throws -> OAuthToken {
        return loginToken
    }

    public func loginWithBrowser() async throws -> OAuthToken {
        return loginToken
    }

    public func refresh(token: OAuthToken) async throws -> OAuthToken {
        return refreshedToken
    }

    public func logout() async throws {
        didLogout = true
    }
}

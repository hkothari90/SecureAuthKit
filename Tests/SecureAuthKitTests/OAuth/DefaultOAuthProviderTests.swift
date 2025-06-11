//
//  DefaultOAuthProviderTests.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import XCTest
@testable import SecureAuthKitMocks
@testable import SecureAuthKit

final class DefaultOAuthProviderTests: XCTestCase {

    private var provider: DefaultOAuthProvider!

    override func setUp() {
        super.setUp()
        provider = DefaultOAuthProvider(
            clientID: "test-client-id",
            authEndpoint: URL(string: "https://example.com/auth")!,
            tokenEndpoint: URL(string: "https://example.com/token")!,
            redirectURI: URL(string: "myapp://callback")!,
            dpop: MockDPoPKeyManager()
        )
    }

    func testLoginWithUsernamePassword_returnsToken() async throws {
        let token = try await provider.login(username: "user", password: "pass")
        XCTAssertEqual(token.accessToken, "dummy-access-token")
    }

    func testRefreshToken_returnsNewToken() async throws {
        let originalToken = OAuthToken(
            accessToken: "old-access-token",
            tokenType: "Bearer",
            expiresIn: 3600,
            refreshToken: "refresh-token",
            scope: nil,
            idToken: nil
        )

        let newToken = try await provider.refresh(token: originalToken)
        XCTAssertEqual(newToken.accessToken, "dummy-access-token")
    }

    func testLoginWithBrowser_returnsToken() async throws {
        let token = try await provider.loginWithBrowser()
        XCTAssertEqual(token.accessToken, "dummy-access-token")
    }

    func testLogout_doesNotThrow() async throws {
        do {
            try await provider.logout()
        } catch {
            XCTFail("Logout should not throw")
        }
    }
}

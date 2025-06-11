//
//  OAuthProviderTests.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import XCTest
@testable import SecureAuthKit
@testable import SecureAuthKitMocks

final class OAuthProviderTests: XCTestCase {

    func testLoginWithBrowserReturnsToken() async throws {
        let expectedToken = OAuthToken.mockToken
        let provider = MockOAuthProvider(loginToken: expectedToken)

        let token = try await provider.loginWithBrowser()
        XCTAssertEqual(token, expectedToken)
    }

    func testLoginWithCredentialsReturnsToken() async throws {
        let expectedToken = OAuthToken.mockToken
        let provider = MockOAuthProvider(loginToken: expectedToken)

        let token = try await provider.login(username: "user", password: "pass")
        XCTAssertEqual(token, expectedToken)
    }

    func testRefreshReturnsUpdatedToken() async throws {
        let expectedToken = OAuthToken.mockToken
        let provider = MockOAuthProvider(refreshedToken: expectedToken)

        let refreshed = try await provider.refresh(token: .mockToken)
        XCTAssertEqual(refreshed, expectedToken)
    }

    func testLogoutSetsFlag() async throws {
        let provider = MockOAuthProvider()
        XCTAssertFalse(provider.didLogout)

        try await provider.logout()
        XCTAssertTrue(provider.didLogout)
    }
}

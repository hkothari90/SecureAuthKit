//
//  OAuthTokenTests.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import XCTest
@testable import SecureAuthKit

final class OAuthTokenTests: XCTestCase {

    func testTokenIsNotExpired_whenWithinValidPeriod() {
        let token = OAuthToken(
            accessToken: "abc",
            tokenType: "Bearer",
            expiresIn: 3600,
            refreshToken: "refresh",
            scope: nil,
            idToken: nil,
            createdAt: Date()
        )

        XCTAssertFalse(token.isExpired)
    }

    func testTokenIsExpired_whenBeyondExpiryBuffer() {
        let expiredToken = OAuthToken(
            accessToken: "abc",
            tokenType: "Bearer",
            expiresIn: 3600,
            refreshToken: "refresh",
            scope: nil,
            idToken: nil,
            createdAt: Date(timeIntervalSinceNow: -4000)
        )

        XCTAssertTrue(expiredToken.isExpired)
    }

    func testCanRefresh_whenRefreshTokenExists() {
        let token = OAuthToken(
            accessToken: "abc",
            tokenType: "Bearer",
            expiresIn: nil,
            refreshToken: "refresh-token",
            scope: nil,
            idToken: nil
        )

        XCTAssertTrue(token.canRefresh)
    }

    func testCannotRefresh_whenRefreshTokenMissing() {
        let token = OAuthToken(
            accessToken: "abc",
            tokenType: "Bearer",
            expiresIn: nil,
            refreshToken: nil,
            scope: nil,
            idToken: nil
        )

        XCTAssertFalse(token.canRefresh)
    }

    func testEquality_betweenIdenticalTokens() {
        let now = Date()
        let token1 = OAuthToken(
            accessToken: "abc",
            tokenType: "Bearer",
            expiresIn: 3600,
            refreshToken: "xyz",
            scope: "openid",
            idToken: "id123",
            createdAt: now
        )

        let token2 = OAuthToken(
            accessToken: "abc",
            tokenType: "Bearer",
            expiresIn: 3600,
            refreshToken: "xyz",
            scope: "openid",
            idToken: "id123",
            createdAt: now
        )

        XCTAssertEqual(token1, token2)
    }

    func testMockFactory_returnsValidToken() {
        let mock = OAuthToken.mockToken
        XCTAssertFalse(mock.accessToken.isEmpty)
        XCTAssertNotNil(mock.createdAt)
    }
}

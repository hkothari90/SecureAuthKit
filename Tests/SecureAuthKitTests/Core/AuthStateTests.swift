//
//  AuthStateTests.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import XCTest
import SecureAuthKitMocks
@testable import SecureAuthKit

final class AuthStateTests: XCTestCase {

    func testUnauthenticatedCase() {
        let state = AuthState.unauthenticated

        XCTAssertFalse(state.isAuthenticated)
        XCTAssertNil(state.token)
    }

    func testAuthenticatedCase() {
        let token = OAuthToken.mockToken
        let state = AuthState.authenticated(token)

        XCTAssertTrue(state.isAuthenticated)
        XCTAssertEqual(state.token, token)
    }

    func testEqualityChecks() {
        XCTAssertEqual(AuthState.unauthenticated, AuthState.unauthenticated)

        let token = OAuthToken.mockToken
        XCTAssertEqual(AuthState.authenticated(token), AuthState.authenticated(token))
    }
}

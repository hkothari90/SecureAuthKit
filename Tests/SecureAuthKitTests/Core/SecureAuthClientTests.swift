//
//  SecureAuthClientTests.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import XCTest
@testable import SecureAuthKit
@testable import SecureAuthKitMocks

final class SecureAuthClientTests: XCTestCase {

    private var client: SecureAuthClient!
    private var events: [AuthState] = []

    override func setUp() {
        client = SecureAuthClient(
            storage: MockTokenStorage(),
            provider: MockOAuthProvider(),
            biometric: MockBiometricAuthenticator(result: .success)
        )

        Task {
            for await event in await client.lifecycleEvents() {
                self.events.append(event)
            }
        }
    }

    func testLoginWithCredentials_succeedsAndEmitsEvent() async throws {
        try await client.loginWithCredentials(username: "demo", password: "pass")
        let state = await client.currentState()

        XCTAssertTrue(state.isAuthenticated)
        XCTAssertTrue(events.contains { if case .authenticated = $0 { return true } else { return false } })
    }

    func testLoginWithBrowser_succeeds() async throws {
        try await client.loginWithBrowser()
        let state = await client.currentState()

        XCTAssertTrue(state.isAuthenticated)
        XCTAssertTrue(events.contains { if case .authenticated = $0 { return true } else { return false } })
    }

    func testLogout_resetsStateAndEmitsEvent() async throws {
        try await client.loginWithCredentials(username: "demo", password: "pass")
        try await client.logout()
        let state = await client.currentState()

        XCTAssertEqual(state, .unauthenticated)
        XCTAssertTrue(events.contains(.unauthenticated))
    }
}

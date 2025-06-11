//
//  KeychainTokenStorageTests.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import XCTest
@testable import SecureAuthKit

final class KeychainTokenStorageTests: XCTestCase {

    private var storage: KeychainTokenStorage!

    override func setUp() {
        super.setUp()
        storage = KeychainTokenStorage()
        try? storage.clear()
    }

    override func tearDown() {
        try? storage.clear()
        storage = nil
        super.tearDown()
    }

    func testSavingAndLoadingToken() throws {
        let token = OAuthToken(
            accessToken: "abc123",
            tokenType: "Bearer",
            expiresIn: 3600,
            refreshToken: "refresh123",
            scope: "openid profile",
            idToken: "idtoken.jwt",
            createdAt: Date()
        )

        try storage.save(token)
        let loadedToken = try storage.load()

        XCTAssertNotNil(loadedToken)
        XCTAssertEqual(loadedToken?.accessToken, token.accessToken)
        XCTAssertEqual(loadedToken?.refreshToken, token.refreshToken)
    }

    func testClearRemovesToken() throws {
        let token = OAuthToken(
            accessToken: "abc123",
            tokenType: "Bearer",
            expiresIn: 3600,
            refreshToken: "refresh123",
            scope: "openid profile",
            idToken: "idtoken.jwt",
            createdAt: Date()
        )

        try storage.save(token)
        try storage.clear()

        let cleared = try storage.load()
        XCTAssertNil(cleared)
    }

    func testOverwritingToken() throws {
        let firstToken = OAuthToken(
            accessToken: "token1",
            tokenType: "Bearer",
            expiresIn: 3600,
            refreshToken: "refresh1",
            scope: "openid",
            idToken: nil,
            createdAt: Date()
        )

        try storage.save(firstToken)

        let secondToken = OAuthToken(
            accessToken: "token2",
            tokenType: "Bearer",
            expiresIn: 7200,
            refreshToken: "refresh2",
            scope: "profile",
            idToken: nil,
            createdAt: Date()
        )

        try storage.save(secondToken)

        let loaded = try storage.load()
        XCTAssertEqual(loaded?.accessToken, "token2")
        XCTAssertEqual(loaded?.refreshToken, "refresh2")
    }
}

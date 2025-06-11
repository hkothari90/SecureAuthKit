//
//  DPoPKeyManagerTests.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import XCTest
@testable import SecureAuthKit

final class DPoPKeyManagerTests: XCTestCase {

    func testSignGeneratesValidJWT() throws {
        let manager = DPoPKeyManager()
        let url = URL(string: "https://api.example.com/protected")!
        let jwt = try manager.sign(method: "GET", url: url)

        XCTAssertFalse(jwt.isEmpty, "Signed JWT should not be empty")
        XCTAssertTrue(jwt.contains("."), "JWT should contain at least one dot ('.')")
    }

    func testPublicKeyThumbprintFormat() throws {
        let manager = DPoPKeyManager()
        let thumbprint = try manager.publicKeyThumbprint()

        XCTAssertFalse(thumbprint.isEmpty, "Thumbprint should not be empty")
        XCTAssertFalse(thumbprint.contains("+"), "Should be Base64URL encoded")
        XCTAssertFalse(thumbprint.contains("/"), "Should be Base64URL encoded")
        XCTAssertFalse(thumbprint.contains("="), "Should be Base64URL encoded")
    }
}

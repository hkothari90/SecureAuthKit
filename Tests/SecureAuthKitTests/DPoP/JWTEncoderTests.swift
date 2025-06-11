//
//  JWTEncoderTests.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import XCTest
import CryptoKit
@testable import SecureAuthKit

final class JWTEncoderTests: XCTestCase {

    func testEncodeDPoPGeneratesJWTWithThreeParts() throws {
        let encoder = JWTEncoder()
        let key = try SecureEnclave.P256.Signing.PrivateKey()
        let url = URL(string: "https://example.com/api/resource")!
        let jwt = try encoder.encodeDPoP(using: key, method: "GET", url: url)

        let parts = jwt.split(separator: ".")
        XCTAssertEqual(parts.count, 3, "JWT must have header, payload, signature")
    }

    func testEncodedJWTContainsNoPadding() throws {
        let encoder = JWTEncoder()
        let key = try SecureEnclave.P256.Signing.PrivateKey()
        let url = URL(string: "https://example.com/secure")!
        let jwt = try encoder.encodeDPoP(using: key, method: "POST", url: url)

        XCTAssertFalse(jwt.contains("="), "JWT should not contain base64 padding")
    }

    func testBase64URLEncodingCompliance() throws {
        let sampleData = Data("unit-test-string".utf8)
        let encoded = sampleData.base64URLEncoded()

        XCTAssertFalse(encoded.contains("+"))
        XCTAssertFalse(encoded.contains("/"))
        XCTAssertFalse(encoded.contains("="))
    }
}

//
//  SecureAuthErrorTests.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import XCTest
@testable import SecureAuthKit

final class SecureAuthErrorTests: XCTestCase {

    func testEquatable_forIdenticalCases() {
        XCTAssertEqual(SecureAuthError.invalidCallback, SecureAuthError.invalidCallback)
    }

    func testEquatable_forDifferentCases() {
        XCTAssertNotEqual(SecureAuthError.invalidRequest, SecureAuthError.invalidCallback)
    }

    func testDescriptions_areNonEmpty() {
        let errors: [SecureAuthError] = [
            .keychainFailure,
            .enclaveFailure,
            .biometricFailure,
            .invalidCredentials,
            .missingRefreshToken,
            .invalidRequest,
            .invalidCallback,
            .networkFailure
        ]

        for error in errors {
            let description = String(describing: error)
            XCTAssertFalse(description.isEmpty, "Expected non-empty description for \(error)")
        }
    }

    func testCanBeThrownAndCaught() {
        do {
            throw SecureAuthError.invalidCredentials
        } catch {
            XCTAssertTrue(error is SecureAuthError)
        }
    }
}

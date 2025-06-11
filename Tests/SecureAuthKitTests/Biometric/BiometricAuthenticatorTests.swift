//
//  BiometricAuthenticatorTests.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import XCTest
import SecureAuthKitMocks
@testable import SecureAuthKit

final class BiometricAuthenticatorTests: XCTestCase {

    func testSuccessResult() async {
        let auth = MockBiometricAuthenticator(result: .success)
        let result = await auth.authenticate(reason: "")

        switch result {
        case .success:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected success but got \(result)")
        }
    }

    func testCancelledResult() async {
        let auth = MockBiometricAuthenticator(result: .failed(.cancelled))
        let result = await auth.authenticate(reason: "")

        switch result {
        case .failed(let error):
            XCTAssertTrue(error == .cancelled)
        default:
            XCTFail("Expected cancelled but got \(result)")
        }
    }
}

//
//  MockBiometricAuthenticator.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import SecureAuthKit

/// A deterministic mock of BiometricAuthenticator for testing login flows.
public struct MockBiometricAuthenticator: BiometricAuthenticating {
    
    private let result: BiometricAuthenticator.Result

    public init(result: BiometricAuthenticator.Result = .success) {
        self.result = result
    }
    
    public var isEnrolled: Bool { return true }
    public var canAuthenticate: Bool { return true }

    public func authenticate(reason: String) async -> BiometricAuthenticator.Result {
        switch result {
        case .success:
            return .success

        case .failed(let error):
            return .failed(error)
        }
    }
}

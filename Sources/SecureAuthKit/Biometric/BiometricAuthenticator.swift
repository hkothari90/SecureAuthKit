//
//  BiometricAuthenticator.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import LocalAuthentication
import Foundation
import UIKit

/// Protocol wrapper for biometric authentication (used for testing).
public protocol BiometricAuthenticating: Sendable {
    var canAuthenticate: Bool { get }
    func authenticate(reason: String) async -> BiometricAuthenticator.Result
}

/// Handles biometric authentication (Face ID / Touch ID) with optional passcode fallback.
public final class BiometricAuthenticator: @unchecked Sendable {

    public enum Result: Equatable, Sendable {
        case success
        case failed(BiometricError)
    }

    public enum BiometricError: Error, Equatable {
        case notEnrolled
        case fallback
        case cancelled
        case unavailable
        case lockedOut
        case unknown

        public static func == (lhs: BiometricError, rhs: BiometricError) -> Bool {
            switch (lhs, rhs) {
            case (.fallback, .fallback),
                (.notEnrolled, .notEnrolled),
                (.cancelled, .cancelled),
                (.unavailable, .unavailable),
                (.lockedOut, .lockedOut),
                (.unknown, .unknown):
                return true
            default:
                return false
            }
        }
    }

    private let context: LAContext

    public init(context: LAContext = LAContext()) {
        self.context = context
    }

    /// Indicates if any biometric authentication method is available on device.
    public var canAuthenticate: Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    /// Performs biometric authentication.
    /// - Parameter reason: Description shown in Face ID/Touch ID prompt.
    public func authenticate(reason: String = "Authenticate to continue") async -> Result {
        guard canAuthenticate else {
            return .failed(.unavailable)
        }

        return await withCheckedContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    continuation.resume(returning: .success)
                } else {
                    continuation.resume(returning: .failed(self.mapLAError(error)))
                }
            }
        }
    }

    private func mapLAError(_ error: Error?) -> BiometricError {
        guard let error = error as? LAError else {
            return .unknown
        }

        switch error.code {
        case .biometryNotEnrolled: return .notEnrolled
        case .userFallback: return .fallback
        case .userCancel: return .cancelled
        case .biometryNotAvailable: return .unavailable
        case .biometryLockout: return .lockedOut
        default: return .unknown
        }
    }
}

extension BiometricAuthenticator: BiometricAuthenticating {}

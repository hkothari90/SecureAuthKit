//
//  SecureAuthError.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

/// Common errors thrown by SecureAuthKit components.
public enum SecureAuthError: Error, Sendable {
    case keychainFailure
    case enclaveFailure
    case biometricFailure
    case invalidCredentials
    case missingRefreshToken
    case invalidRequest
    case invalidCallback
    case networkFailure
    case tokenNotFound
    case unknown(Error)
}

extension SecureAuthError: Equatable {
    public static func == (lhs: SecureAuthError, rhs: SecureAuthError) -> Bool {
        switch (lhs, rhs) {
        case (.keychainFailure, .keychainFailure),
            (.enclaveFailure, .enclaveFailure),
            (.biometricFailure, .biometricFailure),
            (.invalidCredentials, .invalidCredentials),
            (.tokenNotFound, .tokenNotFound),
            (.missingRefreshToken, .missingRefreshToken),
            (.invalidRequest, .invalidRequest),
            (.invalidCallback, .invalidCallback),
            (.networkFailure, .networkFailure):
            return true
        case (.unknown, .unknown):
            return true // Treat unknowns as equal for Equatable
        default:
            return false
        }
    }
}

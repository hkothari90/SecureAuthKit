//
//  AuthState.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

/// Represents the authentication state of the client.
public enum AuthState: Equatable, Sendable {
    case loading
    case unauthenticated
    case authenticated(OAuthToken)
    case failed(SecureAuthError)

    public var token: OAuthToken? {
        if case let .authenticated(token) = self {
            return token
        }
        return nil
    }

    public var isAuthenticated: Bool {
        if case .authenticated = self {
            return true
        }
        return false
    }
} 

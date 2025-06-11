//
//  SecureAuthClient.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

// Main authentication controller for secure state and OAuth handling.
// Orchestrates login, refresh, logout, and state management for SecureAuthKit
public actor SecureAuthClient: Sendable {
    
    // MARK: - Dependencies
    private let storage: TokenStorage
    private let provider: OAuthProvider
    private let biometric: BiometricAuthenticating?
    
    // MARK: - State
    private var state: AuthState = .unauthenticated
    private var streamContinuation: AsyncStream<AuthState>.Continuation?
    
    // MARK: - Init
    public init(
        storage: TokenStorage,
        provider: OAuthProvider,
        biometric: BiometricAuthenticating? = nil
    ) {
        self.storage = storage
        self.provider = provider
        self.biometric = biometric
    }
    
    // MARK: - Public APIs
    public var canUseBiometrics: Bool {
        biometric?.canAuthenticate ?? false
    }
    
    public func currentState() -> AuthState {
        return state
    }
    
    public func lifecycleEvents() -> AsyncStream<AuthState> {
        return AsyncStream { continuation in
            self.streamContinuation = continuation
        }
    }
    
    public func loginWithBrowser() async throws {
        streamContinuation?.yield(.loading)
        
        let token = try await provider.loginWithBrowser()
        try storage.save(token)
        state = .authenticated(token)
        streamContinuation?.yield(state)
    }
    
    public func loginWithCredentials(username: String, password: String) async throws {
        streamContinuation?.yield(.loading)
        
        let token = try await provider.login(username: username, password: password)
        try storage.save(token)
        state = .authenticated(token)
        streamContinuation?.yield(state)
    }
    
    public func logout() async throws {
        streamContinuation?.yield(.loading)
        
        try await provider.logout()
        try storage.clear()
        state = .unauthenticated
        streamContinuation?.yield(state)
    }
    
    public func authenticateWithBiometrics() async throws {
        guard let biometric = biometric else {
            throw SecureAuthError.biometricFailure
        }
        streamContinuation?.yield(.loading)
        let result = await biometric.authenticate(reason: "Authenticate to continue")
        switch result {
        case .success:
            if let token = try storage.load() {
                if token.isExpired, token.canRefresh {
                    let refreshed = try await provider.refresh(token: token)
                    try storage.save(refreshed)
                    state = .authenticated(refreshed)
                    streamContinuation?.yield(state)
                } else {
                    state = .authenticated(token)
                    streamContinuation?.yield(.authenticated(token))
                }
            } else {
                throw SecureAuthError.tokenNotFound
            }
        case .failed(let error):
            throw error
        }
    }
}

//
//  AuthViewModel.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import Combine
import SwiftUI
import SecureAuthKit

/// A view model that manages authentication state and user interactions with the SecureAuthClient.
/// Handles login, biometric authentication, and state restoration across app launches.
@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var authState: AuthState = .unauthenticated
    @Published var shouldShowBiometricOnboarding = false
    @Published var isBiometricEnrolled = BiometricPreference.isEnrolled
    @Published var error: SecureAuthError?
    
    private let client: SecureAuthClient
    private var eventStreamTask: Task<Void, Never>?
    
    /// Initializes the view model with a `SecureAuthClient` instance.
    init(client: SecureAuthClient) {
        self.client = client
        bindLifecycleEvents()
    }
    
    deinit {
        eventStreamTask?.cancel()
    }
    
    /// Performs login using username and password.
    /// Saves user’s biometric preference on success.
    func loginWithCredentials(username: String, password: String) {
        Task {
            do {
                try await client.loginWithCredentials(username: username, password: password)
                await showBiometricOnboardingIfNeeded()
            } catch {
                self.authState = .failed(error as? SecureAuthError ?? .invalidCredentials)
            }
        }
    }
    
    /// Initiates browser-based login using OAuth2 Authorization Code Flow.
    /// Saves biometric preference on success.
    func loginWithBrowser() {
        Task {
            do {
                try await client.loginWithBrowser()
                await showBiometricOnboardingIfNeeded()
            } catch {
                self.authState = .failed(error as? SecureAuthError ?? .invalidCallback)
            }
        }
    }
    
    /// Triggers biometric authentication if available.
    func authenticateWithBiometrics() {
        Task {
            do {
                try await client.authenticateWithBiometrics()
            } catch {
                self.authState = .failed(error as? SecureAuthError ?? .biometricFailure)
            }
        }
    }
    
    /// Logs out the user and removes biometric preference.
    func logout() {
        Task {
            try? await client.logout()
            BiometricPreference.setEnrolled(false)
            isBiometricEnrolled = false
        }
    }
    
    /// Subscribes to lifecycle events from SecureAuthClient and updates UI state accordingly.
    private func bindLifecycleEvents() {
        eventStreamTask = Task {
            for await event in await client.lifecycleEvents() {
                await MainActor.run {
                    switch event {
                    case .loading:
                        isLoading = true
                    case .authenticated(let token):
                        self.authState = .authenticated(token)
                        isLoading = false
                    case .unauthenticated:
                        self.authState = .unauthenticated
                        isLoading = false
                    case .failed(let error):
                        self.authState = .failed(error)
                        isLoading = false
                    }
                }
            }
        }
    }
    
    private func showBiometricOnboardingIfNeeded() async {
        if await client.canUseBiometrics && !BiometricPreference.isEnrolled {
            shouldShowBiometricOnboarding = true
        }
    }
}

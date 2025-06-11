//
//  ExampleApp.swift
//  ExampleApp
//
//  Created by Hardik Kothari on 10.06.25.
//

import SwiftUI
import SecureAuthKit
import SecureAuthKitMocks

@main
struct ExampleApp: App {
    
    @StateObject private var viewModel: AuthViewModel
    
    init() {
        let client = SecureAuthClient.mock()
        _viewModel = StateObject(wrappedValue: AuthViewModel(client: client))
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: viewModel)
        }
    }
}

extension SecureAuthClient {
    public static func mock() -> SecureAuthClient {
        return SecureAuthClient(
            storage: KeychainTokenStorage(),
            provider: MockOAuthProvider(),
            biometric: BiometricAuthenticator()
        )
    }
}

//
//  RootView.swift
//  ExampleApp
//
//  Created by Hardik Kothari on 10.06.25.
//

import SwiftUI

/// Root view that handles routing based on authentication state.
struct RootView: View {
    @StateObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            content
                .animation(.easeInOut, value: viewModel.authState)
                .fullScreenCover(isPresented: $viewModel.shouldShowBiometricOnboarding) {
                    BiometricOnboardingView(
                        onAccept: {
                            BiometricPreference.setEnrolled(true)
                            viewModel.shouldShowBiometricOnboarding = false
                        },
                        onSkip: {
                            viewModel.shouldShowBiometricOnboarding = false
                        }
                    )
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.authState {
        case .loading:
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))

        case .unauthenticated, .failed:
            LoginView(viewModel: viewModel)

        case .authenticated:
            HomeView(viewModel: viewModel)
        }
    }
}

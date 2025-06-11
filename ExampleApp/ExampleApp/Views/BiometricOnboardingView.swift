//
//  BiometricOnboardingView.swift
//  ExampleApp
//
//  Created by Hardik Kothari on 10.06.25.
//

import SwiftUI

struct BiometricOnboardingView: View {
    var onAccept: () -> Void
    var onSkip: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.accentColor.opacity(0.1), Color.white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                Image(systemName: "faceid")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .padding()
                    .background(Color.accentColor.opacity(0.1))
                    .clipShape(Circle())

                VStack(spacing: 10) {
                    Text("Enable Face ID / Touch ID")
                        .font(.title2.weight(.semibold))
                        .multilineTextAlignment(.center)

                    Text("Speed up your future logins and enhance security using biometrics.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                VStack(spacing: 12) {
                    Button(action: onAccept) {
                        Text("Enable Biometrics")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }

                    Button(action: onSkip) {
                        Text("Maybe Later")
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}

//
//  LoginView.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // App branding
            Image(systemName: "lock.shield")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .padding()
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Circle())

            Text("Secure Login")
                .font(.largeTitle.weight(.bold))

            // Credentials
            VStack(spacing: 16) {
                TextField("Username", text: $username)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                Button(action: {
                    Task {
                        viewModel.loginWithCredentials(username: username, password: password)
                    }
                }) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }

            // OAuth / Browser login
            Button(action: {
                Task {
                    viewModel.loginWithBrowser()
                }
            }) {
                Label("Login with Browser", systemImage: "globe")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
            }

            // Biometric login (if enrolled)
            if viewModel.isBiometricEnrolled {
                VStack(spacing: 8) {
                    Text("or")
                        .foregroundColor(.secondary)

                    Button(action: {
                        Task {
                            viewModel.authenticateWithBiometrics()
                        }
                    }) {
                        Label("Login with Face ID / Touch ID", systemImage: "faceid")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.tertiarySystemBackground))
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}

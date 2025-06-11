//
//  HomeView.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if case let .authenticated(token) = viewModel.authState,
                   let claims = token.idTokenClaims {
                    Spacer()
                    
                    Image(systemName: "person.crop.circle.fill.badge.checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.accentColor)
                    
                    Text("Welcome!")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .center, spacing: 8) {
                        if let name = claims.name {
                            Text("👤 \(name)")
                                .font(.title)
                                .bold()
                                .foregroundColor(.secondary)
                        }
                        if let email = claims.email {
                            Text("📧 \(email)")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    Button {
                        viewModel.logout()
                    } label: {
                        Text("Log Out")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentColor.opacity(0.1))
                            )
                    }
                    .foregroundColor(.accentColor)
                    .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

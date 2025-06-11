//
//  TokenStorage.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

/// Abstract protocol for securely storing OAuth tokens.
public protocol TokenStorage: Sendable {
    func save(_ token: OAuthToken) throws
    func load() throws -> OAuthToken?
    func clear() throws
}

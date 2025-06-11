//
//  MockTokenStorage.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import SecureAuthKit

/// A simple in-memory storage for OAuthToken, used for testing.
public final class MockTokenStorage: TokenStorage, @unchecked Sendable {
    private var token: OAuthToken?
    private let lock = NSLock()

    public init(initial: OAuthToken? = nil) {
        self.token = initial
    }

    public func save(_ token: OAuthToken) throws {
        lock.lock()
        self.token = token
        lock.unlock()
    }

    public func load() throws -> OAuthToken? {
        lock.lock()
        let value = token
        lock.unlock()
        return value
    }

    public func clear() throws {
        lock.lock()
        self.token = nil
        lock.unlock()
    }
}

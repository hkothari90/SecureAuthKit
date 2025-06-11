//
//  MockDPoPKeyManager.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import Security
import SecureAuthKit

final class MockDPoPKeyManager: DPoPKeyManaging {

    func sign(method: String, url: URL) throws -> String {
        return """
        eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImdpdmVuIjoiTW9ja2VkIn0.\
        eyJodHUiOiJodHRwczovL2V4YW1wbGUuY29tL3Rlc3QiLCJodG0iOiJHRVQiLCJqdGkiOiJ0ZXN0LWp3dCIsImlhdCI6MTY5MDAwMDAwMH0.\
        signature
        """
    }

    func publicKeyThumbprint() throws -> String {
        return "mocked-thumbprint"
    }
}

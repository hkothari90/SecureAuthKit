//
//  BiometricPreference.swift
//  ExampleApp
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation

// Services/BiometricPreference.swift
final class BiometricPreference {
    private static let key = "biometric_enrolled"

    static var isEnrolled: Bool {
        UserDefaults.standard.bool(forKey: key)
    }

    static func setEnrolled(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }
}

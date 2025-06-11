//
//  OAuthToken+Mock.swift
//  SecureAuthKit
//
//  Created by Hardik Kothari on 10.06.25.
//

import Foundation
import SecureAuthKit

public extension OAuthToken {
    static var mockToken: OAuthToken {
        OAuthToken(
            accessToken: "abc123.access.token",
            tokenType: "Bearer",
            expiresIn: 3600,
            refreshToken: "xyz789.refresh.token",
            scope: "openid email profile",
            idToken: IDTokenClaims.mockJWT,
            createdAt: Date()
        )
    }
}

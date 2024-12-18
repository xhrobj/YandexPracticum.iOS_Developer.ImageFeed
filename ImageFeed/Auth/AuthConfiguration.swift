//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 16.11.2024.
//

// NOTE: https://unsplash.com/documentation/user-authentication-workflow

struct AuthConfiguration {
    static var standard: AuthConfiguration {
        AuthConfiguration(
            accessKey: OAuth2Constants.accessKey,
            secretKey: OAuth2Constants.secretKey,
            redirectURI: OAuth2Constants.redirectURI,
            accessScope: OAuth2Constants.accessScope,
            authLink: OAuth2Constants.unsplashAuthorizeLink
        )
    }
    
    static var test: AuthConfiguration {
        AuthConfiguration(
            accessKey: "_USINTInvn-ZujfkU4zG345S8ZrqEbFvPc-NbJo6Pck",
            secretKey: "1Kpbm9lRCZ4cgB8xmn0zVMoILIr3ZVH6y3HO-0jGzN8",
            redirectURI: "urn:ietf:wg:oauth:2.0:oob",
            accessScope: OAuth2Constants.accessScope,
            authLink: OAuth2Constants.unsplashAuthorizeLink
        )
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authLink: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authLink: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authLink = authLink
    }
}

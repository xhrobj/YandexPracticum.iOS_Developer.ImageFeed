//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 16.11.2024.
//

import Foundation

final class AuthHelper {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
}

// MARK: - <AuthHelperProtocol>

extension AuthHelper: AuthHelperProtocol {
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        guard
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        else {
            return nil
        }
        
        return codeItem.value
    }
}

// MARK: - Private methods

private extension AuthHelper {
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.authLink) else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        let url = urlComponents.url
        
        return url
    }
}

//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 05.11.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service.create()
    
    private let networkClient: NetworkRouting
    private var currentNetworkClientTask: URLSessionDataTask?
    
    private var lastCode: String?
    
    private init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
    }
    
    static func create(networkClient: NetworkRouting = NetworkClient()) -> OAuth2Service {
        return OAuth2Service(networkClient: networkClient)
    }
}

// MARK: - <OAuth2ServiceProtocol>

extension OAuth2Service: OAuth2ServiceProtocol {
    
    // https://unsplash.com/documentation/user-authentication-workflow#authorization-workflow (look at #3)
    
    func fetchOAuth2Token(for code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard currentNetworkClientTask == nil || lastCode != code else {
            let error = ServiceError.unexpectedRequest
            print("[OAuth2Service/fetchOAuth2Token]: ServiceError ->", error.localizedDescription)
            completion(.failure(error))
            
            return
        }

        currentNetworkClientTask?.cancel()
        lastCode = code

        guard let request = makeOAuthTokenRequest(with: code) else {
            let error = ServiceError.invalidURL
            print("[OAuth2Service/fetchOAuth2Token]: ServiceError ->", error.localizedDescription)
            completion(.failure(error))
            
            return
        }
        
        currentNetworkClientTask = networkClient
            .fetchObject(for: request) { [weak self] (result: Result<OAuth2TokenResponseDTO, Error>) in
            
            self?.currentNetworkClientTask = nil
            
            switch result {
            case .success(let response):
                completion(.success(response.accessToken))
                
            case .failure(let error):
                print("[OAuth2Service/fetchOAuth2Token]: NetworkError ->", error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private methods

private extension OAuth2Service {
    func makeOAuthTokenRequest(with code: String) -> URLRequest? {
        guard let baseURL = URL(string: Constants.baseURL) else {
            return nil
        }
        
        var components = URLComponents()
        components.path = Constants.tokenPath
        components.queryItems = [
            URLQueryItem(name: "client_id", value: AuthConfiguration.standard.accessKey),
            URLQueryItem(name: "client_secret", value: AuthConfiguration.standard.secretKey),
            URLQueryItem(name: "redirect_uri", value: AuthConfiguration.standard.redirectURI),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code)
        ]
        
        guard let url = components.url(relativeTo: baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = NetworkHTTPMethod.POST.rawValue
        
        return request
    }
}

// MARK: - Constants

private extension OAuth2Service {
     enum Constants {
         static let baseURL = "https://unsplash.com"
         static let tokenPath = "/oauth/token"
    }
}

//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 05.11.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let networkClient: NetworkRouting
    private var currentNetworkClientTask: URLSessionDataTask?
    
    private var lastCode: String?
    
    private init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - <OAuth2ServiceProtocol>

extension OAuth2Service: OAuth2ServiceProtocol {
    func fetchOAuth2Token(for code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if let task = currentNetworkClientTask {
            if lastCode == code {
                completion(.failure(OAuth2ServiceError.unexpectedRequest))
                return
            }
            task.cancel()
        } else if lastCode == code {
            completion(.failure(OAuth2ServiceError.unexpectedRequest))
            return
        }

        lastCode = code

        guard let request = makeOAuthTokenRequest(with: code) else {
            completion(.failure(OAuth2ServiceError.invalidURL))
            return
        }
        
        currentNetworkClientTask = networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                let response: OAuth2TokenResponseDTO
                
                do {
                    response = try JSONDecoder().decode(OAuth2TokenResponseDTO.self, from: data)
                } catch {
                    completion(.failure(OAuth2ServiceError.decodingError))
                    return
                }
                
                completion(.success(response.accessToken))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private methods

private extension OAuth2Service {
    func makeOAuthTokenRequest(with code: String) -> URLRequest? {
        guard let baseURL = URL(string: OAuth2Constants.baseURL) else {
            return nil
        }
        
        var components = URLComponents()
        components.path = OAuth2Constants.tokenPath
        components.queryItems = [
            URLQueryItem(name: "client_id", value: OAuth2Constants.accessKey),
            URLQueryItem(name: "client_secret", value: OAuth2Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: OAuth2Constants.redirectURI),
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
    
    enum OAuth2ServiceError: LocalizedError {
        case invalidURL
        case decodingError
        case unexpectedRequest
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Некорректный url или компоненты запроса (✖╭╮✖)"
            case .decodingError:
                return "Ошибка при декодировании ответа (╯°□°）╯︵ ┻━┻"
            case .unexpectedRequest:
                return "Повторяющийся или не соответствующий логике запрос (⊙_☉)"
            }
        }
    }
}

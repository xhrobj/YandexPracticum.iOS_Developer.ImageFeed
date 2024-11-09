//
//  StubNetworkClient.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 05.11.2024.
//

import Foundation

struct NetworkClient: NetworkRouting {
    func fetchObject<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTask? {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkClientError.invalidStatusCode))
                }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkClientError.invalidData))
                }
                return
            }
            
            let response: T

            do {
                response = try JSONDecoder().decode(T.self, from: data)
            } catch {
                completion(.failure(NetworkClientError.decodingError))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(response))
            }
        }
        task.resume()
        
        return task
    }
}

private extension NetworkClient {
    enum NetworkClientError: LocalizedError {
        case invalidStatusCode
        case invalidData
        case decodingError
        
        var errorDescription: String? {
            switch self {
            case .invalidStatusCode:
                return "Код ответа сервера не в пределах ожидаемого диапазона (x_x)"
            case .invalidData:
                return "Ошибка при получении данных с сервера (x_x)"
            case .decodingError:
                return "Ошибка при декодировании ответа (╯°□°）╯︵ ┻━┻"
            }
        }
    }
}

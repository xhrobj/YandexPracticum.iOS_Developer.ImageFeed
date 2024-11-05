//
//  StubNetworkClient.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 05.11.2024.
//

import Foundation

struct NetworkClient: NetworkRouting {
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkClientError.invalidStatusCode))
                return
            }
            
            guard let data else {
                handler(.failure(NetworkClientError.invalidData))
                return
            }
            
            handler(.success(data))
        }
        
        task.resume()
    }
}

private extension NetworkClient {
    enum NetworkClientError: LocalizedError {
        case invalidStatusCode
        case invalidData
        
        var errorDescription: String? {
            switch self {
            case .invalidStatusCode:
                return "Код ответа сервера не в пределах ожидаемого диапазона (x_x)"
            case .invalidData:
                return "Ошибка при получении данных с сервера (x_x)"
            }
        }
    }
}

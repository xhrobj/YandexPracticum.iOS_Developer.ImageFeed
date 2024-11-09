//
//  ServiceError.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.11.2024.
//

import Foundation

enum ServiceError: LocalizedError {
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

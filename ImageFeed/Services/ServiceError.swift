//
//  ServiceError.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.11.2024.
//

import Foundation

enum ServiceError: LocalizedError {
    case invalidURL
    case unexpectedRequest
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный url или компоненты запроса (✖╭╮✖)"
        case .unexpectedRequest:
            return "Повторяющийся или не соответствующий логике запрос (⊙_☉)"
        }
    }
}

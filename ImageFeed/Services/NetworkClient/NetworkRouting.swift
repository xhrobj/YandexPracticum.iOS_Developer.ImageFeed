//
//  StubNetworkClient.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 05.11.2024.
//

import Foundation

protocol NetworkRouting {
    func fetchObject<T: Decodable>(
        for: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTask?
}

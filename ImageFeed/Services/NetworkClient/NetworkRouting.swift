//
//  StubNetworkClient.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 05.11.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

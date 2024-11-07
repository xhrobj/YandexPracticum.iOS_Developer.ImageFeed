//
//  StubNetworkClient.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 06.11.2024.
//

import Foundation

struct StubNetworkClient: NetworkRouting {
    enum TestError: Error {
        case test
    }
    
    let emulateError: Bool
    
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        guard !emulateError else {
            handler(.failure(TestError.test))
            return
        }
        
        handler(.success(expectedResponse))
    }
}

private extension StubNetworkClient {
    var expectedResponse: Data {
        """
        {
            "access_token": "091343ce13c8ae780065ecb3b13dc903475dd22cb78a05503c2e0c69c5e98044",
            "token_type": "bearer",
            "scope": "public read_photos write_photos",
            "created_at": 1436544465
        }
        """.data(using: .utf8) ?? Data()
    }
}

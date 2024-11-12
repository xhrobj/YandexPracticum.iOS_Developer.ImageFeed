//
//  OAuth2ServiceProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 05.11.2024.
//

protocol OAuth2ServiceProtocol {
    var networkClient: NetworkRouting { get }
    
    func fetchOAuth2Token(for code: String, completion: @escaping (Result<String, Error>) -> Void)
}

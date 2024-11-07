//
//  OAuth2TokenResponse.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 05.11.2024.
//

struct OAuth2TokenResponseDTO: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

//
//  PhotoDTO.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 12.11.2024.
//

struct PhotoDTO: Decodable {
    let id: String
    let width, height: Int
    let createdAt: String?
    let description: String?
    let likedByUser: Bool
    let urls: UrlsDTO
    
    private enum CodingKeys: String, CodingKey {
        case id
        case width, height
        case createdAt = "created_at"
        case description
        case likedByUser = "liked_by_user"
        case urls
    }
}

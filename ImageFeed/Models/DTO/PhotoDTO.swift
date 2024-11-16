//
//  PhotoDTO.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 12.11.2024.
//

import Foundation

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

extension PhotoDTO {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    static func photo(from dto: PhotoDTO) -> Photo {
        let createdAtDate = dto.createdAt.flatMap { dateFormatter.date(from: $0) }
        
        return Photo(
            id: dto.id,
            size: CGSize(width: dto.width, height: dto.height),
            createdAt: createdAtDate,
            welcomeDescription: dto.description,
            tinyImageLink: dto.urls.thumb,
            largeImageLink: dto.urls.full,
            isLiked: dto.likedByUser
        )
    }
}

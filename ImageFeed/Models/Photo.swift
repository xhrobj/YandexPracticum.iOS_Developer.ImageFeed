//
//  Photo.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 12.11.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let tinyImageLink: String
    let largeImageLink: String
    let isLiked: Bool
    
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    init(id: String,
         size: CGSize,
         createdAt: Date?,
         welcomeDescription: String?,
         tinyImageLink: String,
         largeImageLink: String,
         isLiked: Bool
    ) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.tinyImageLink = tinyImageLink
        self.largeImageLink = largeImageLink
        self.isLiked = isLiked
    }

    init(_ photo: PhotoDTO) {
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)
        self.createdAt = Photo.dateFormatter.date(from: photo.createdAt ?? "")
        self.welcomeDescription = photo.description
        self.tinyImageLink = photo.urls.thumb
        self.largeImageLink = photo.urls.full
        self.isLiked = photo.likedByUser
    }
}

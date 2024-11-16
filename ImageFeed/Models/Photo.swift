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
    let tinyImageURL: URL?
    let largeImageURL: URL?
    let isLiked: Bool
}

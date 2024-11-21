//
//  Photo.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 12.11.2024.
//

import Foundation
import CoreGraphics

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let tinyImageURL: URL?
    let largeImageURL: URL?
    let isLiked: Bool
}

extension Photo {
    static func mock(
        id: String = UUID().uuidString,
        size: CGSize = CGSize(width: 100, height: 200),
        createdAt: Date? = Date(),
        welcomeDescription: String? = nil,
        tinyImageURL: URL = URL(string: "https://example.com/tiny.jpg")!,
        largeImageURL: URL? = URL(string: "https://example.com/large.jpg"),
        isLiked: Bool = false
    ) -> Photo {
        Photo(
            id: id,
            size: size,
            createdAt: createdAt,
            welcomeDescription: welcomeDescription,
            tinyImageURL: tinyImageURL,
            largeImageURL: largeImageURL,
            isLiked: isLiked
        )
    }
}

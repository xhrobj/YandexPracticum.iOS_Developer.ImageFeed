//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 12.11.2024.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }

    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void)
}

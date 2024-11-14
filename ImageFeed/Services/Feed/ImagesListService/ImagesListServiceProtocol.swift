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
}

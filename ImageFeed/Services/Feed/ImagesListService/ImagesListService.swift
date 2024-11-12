//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 12.11.2024.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    static let shared = ImagesListService.create()
    
    private(set) var photos: [Photo] = []
    
    private let networkClient: NetworkRouting
    private var lastLoadedPage: Int?
    private var currentNetworkClientTask: URLSessionDataTask?
    
    private init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
    }
    
    static func create(networkClient: NetworkRouting = NetworkClient()) -> ImagesListService {
        return ImagesListService(networkClient: networkClient)
    }
}

// MARK: - <ImagesListService>

extension ImagesListService: ImagesListServiceProtocol {
    
    // NOTE: https://unsplash.com/documentation#list-photos
    
    func fetchPhotosNextPage() {
        // ...
    }
} 

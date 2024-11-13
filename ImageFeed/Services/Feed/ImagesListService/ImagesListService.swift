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
    
    private let oauth2Storage: OAuth2TokenStorageProtocol
    private let networkClient: NetworkRouting
    private var currentNetworkClientTask: URLSessionDataTask?
    private var lastLoadedPageNumber = 0
    
    private init(networkClient: NetworkRouting, oauth2Storage: OAuth2TokenStorageProtocol) {
        self.networkClient = networkClient
        self.oauth2Storage = oauth2Storage
    }
    
    static func create(
        networkClient: NetworkRouting = NetworkClient(),
        oauth2Storage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    ) -> ImagesListService {
        return ImagesListService(networkClient: networkClient, oauth2Storage: oauth2Storage)
    }
}

// MARK: - <ImagesListServiceProtocol>

extension ImagesListService: ImagesListServiceProtocol {
    
    // NOTE: https://unsplash.com/documentation#list-photos
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard currentNetworkClientTask == nil else { return }
        
        let nextPageNumber = lastLoadedPageNumber + 1
        
        guard let request = makeGetPhotosNextRequest(for: nextPageNumber, with: Constants.pageSize) else {
            let error = ServiceError.invalidURL
            print("[ImagesListService/fetchPhotosNextPage]: ServiceError ->", error.localizedDescription)
            
            return
        }
        
        currentNetworkClientTask = networkClient.fetchObject(
            for: request
        ) { [weak self] (result: Result<[PhotoDTO], Error>) in
            
            guard let self = self else { return }
            
            self.currentNetworkClientTask = nil
            
            switch result {
            case .success(let response):
                response.forEach { photoDTO in
                    let photo = Photo(
                        id: photoDTO.id,
                        size: CGSize(width: photoDTO.width, height: photoDTO.height),
                        
                        // TODO:
                        createdAt: nil,
                        
                        welcomeDescription: photoDTO.description,
                        thumbImageLink: photoDTO.urls.thumb,
                        largeImageLink: photoDTO.urls.full,
                        isLiked: photoDTO.likedByUser
                    )
                    self.photos.append(photo)
                }
                self.lastLoadedPageNumber = nextPageNumber
                
                self.sendNotification()
                
            case .failure(let error):
                print("[ImagesListService/fetchPhotosNextPage]: NetworkError ->", error.localizedDescription)
            }
        }
    }
}

// MARK: - Private methods

private extension ImagesListService {
    func makeGetPhotosNextRequest(for pageNumber: Int, with pageSize: Int) -> URLRequest? {
        guard let baseURL = URL(string: ServiceConstants.baseURL) else {
            return nil
        }
        
        var components = URLComponents()
        components.path = ServiceConstants.feedPath
        components.queryItems = [
            URLQueryItem(name: "page", value: String(pageNumber)),
            URLQueryItem(name: "per_page", value: String(pageSize))
        ]
        
        guard let url = components.url(relativeTo: baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = NetworkHTTPMethod.GET.rawValue
        
        if let token = oauth2Storage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
    
    func sendNotification() {
        NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
    }
}

// MARK: - Constants

private extension ImagesListService {
     enum Constants {
         static let pageSize = 10
    }
}

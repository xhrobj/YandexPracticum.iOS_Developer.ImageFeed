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
    
    private var currentNetworkClientFetchPhotosTask: URLSessionDataTask?
    private var currentNetworkClientChangeLikeTask: URLSessionDataTask?
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
        
        guard currentNetworkClientFetchPhotosTask == nil else { return }
        
        let nextPageNumber = lastLoadedPageNumber + 1
        
        guard let request = makeGetPhotosNextRequest(for: nextPageNumber, with: Constants.pageSize) else {
            let error = ServiceError.invalidURL
            print("[ImagesListService/fetchPhotosNextPage]: ServiceError ->", error.localizedDescription)
            
            return
        }
        
        currentNetworkClientFetchPhotosTask = networkClient.fetchObject(
            for: request
        ) { [weak self] (result: Result<[PhotoDTO], Error>) in
            
            guard let self = self else { return }
            
            self.currentNetworkClientFetchPhotosTask = nil
            
            switch result {
            case .success(let response):
                let photos = response.map { Photo($0) }
                
                self.photos.append(contentsOf: photos)
                self.lastLoadedPageNumber = nextPageNumber
                
                self.sendNotification()
                
            case .failure(let error):
                print("[ImagesListService/fetchPhotosNextPage]: NetworkError ->", error.localizedDescription)
            }
        }
    }
    
    // NOTE: https://unsplash.com/documentation#like-a-photo
    // NOTE: https://unsplash.com/documentation#unlike-a-photo
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard currentNetworkClientChangeLikeTask == nil else { return }
        
        guard let request = makeChangeLiketRequest(with: photoId, isLike) else {
            let error = ServiceError.invalidURL
            print("[ImagesListService/changeLike]: ServiceError ->", error.localizedDescription)
            
            return
        }
        
        currentNetworkClientChangeLikeTask = networkClient.fetchObject(
            for: request
        ) { [weak self] (result: Result<LikeResponseDTO, Error>) in
            
            guard let self = self else { return }
            
            self.currentNetworkClientChangeLikeTask = nil
            
            switch result {
            case .success(_):
                if let photoIndex = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[photoIndex]
                    self.photos[photoIndex] = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        tinyImageLink: photo.tinyImageLink,
                        largeImageLink: photo.largeImageLink,
                        isLiked: !photo.isLiked)
                }
                
                completion(.success(()))
                
            case .failure(let error):
                print("[ImagesListService/changeLike]: NetworkError ->", error.localizedDescription)
                completion(.failure(error))
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
    
    func makeChangeLiketRequest(with photoId: String, _ isLike: Bool) -> URLRequest? {
        guard let baseURL = URL(string: ServiceConstants.baseURL) else {
            return nil
        }
        
        let path = ServiceConstants.likePathTemplate.replacingOccurrences(of: "{photo_id}", with: photoId)
        let method = isLike ? NetworkHTTPMethod.POST : NetworkHTTPMethod.DELETE
        
        var components = URLComponents()
        components.path = path

        guard let url = components.url(relativeTo: baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
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

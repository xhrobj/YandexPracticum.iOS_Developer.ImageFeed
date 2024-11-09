//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.11.2024.
//

import Foundation

final class ProfileImageService {
    static let didChangeAvatarImageLinkNotification = Notification.Name("ProfileImageProviderDidChange")
    static let notificationAvatarImageLinkKey = "avatarImageLink"
    
    static let shared = ProfileImageService()
    
    private(set) var networkClient: NetworkRouting
    private(set) var profileImageLink: String?
    
    private let oauth2Storage: OAuth2TokenStorageProtocol
    
    private var currentNetworkClientTask: URLSessionDataTask?

    private init(
        networkClient: NetworkRouting = NetworkClient(),
        oauth2Storage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    ) {
        self.networkClient = networkClient
        self.oauth2Storage = oauth2Storage
    }
}

// MARK: - <ProfileImageServiceProtocol>

extension ProfileImageService: ProfileImageServiceProtocol {
    
    // NOTE: https://unsplash.com/documentation#get-a-users-public-profile

    func fetchProfileImageLink(username: String, completion: @escaping (Result<String, any Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard currentNetworkClientTask == nil else { return }

        guard let request = makeGetMyProfileImageRequest(with: username) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        currentNetworkClientTask = networkClient
            .fetchObject(for: request) { [weak self] (result: Result<UserResponseDTO, Error>) in
            
            self?.currentNetworkClientTask = nil
            self?.profileImageLink = nil
            
            switch result {
            case .success(let response):
                let profileImageURL = response.profileImage.medium
                self?.profileImageLink = profileImageURL
                
                self?.sendNotification()
                
                completion(.success(profileImageURL))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private methods

private extension ProfileImageService {
    func makeGetMyProfileImageRequest(with username: String) -> URLRequest? {
        guard let baseURL = URL(string: ProfileServiceConstants.baseURL) else {
            return nil
        }
        
        var components = URLComponents()
        components.path = ProfileServiceConstants.usersPath + username
        
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
        guard let profileImageLink else { return }

        NotificationCenter.default
            .post(
                name: Self.didChangeAvatarImageLinkNotification,
                object: self,
                userInfo: [Self.notificationAvatarImageLinkKey: profileImageLink]
            )
    }
}

//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.11.2024.
//

import Foundation

final class ProfileImageService {
    static let didChangeAvatarImageLinkNotification = Notification.Name(
        rawValue: Constants.didChangeAvatarImageLinkNotification
    )
    static let notificationAvatarImageLinkKey = Constants.notificationAvatarImageLinkKey
    
    static let shared = ProfileImageService()
    
    private(set) var networkClient: NetworkRouting
    private(set) var profileImageLink: String?
    
    private let oauth2Storage: OAuth2TokenStorageProtocol
    
    private var currentNetworkClientTask: URLSessionDataTask?

    private init(
        networkClient: NetworkRouting = NetworkClient(),
        oauth2Storage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
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
        
        currentNetworkClientTask = networkClient.fetch(request: request) { [weak self] result in
            self?.currentNetworkClientTask = nil
            self?.profileImageLink = nil
            
            switch result {
            case .success(let data):

//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Received JSON: \(jsonString)")
//                } else {
//                    print("Failed to convert data to string")
//                }
                    
                let response: UserResponseDTO

                do {
                    response = try JSONDecoder().decode(UserResponseDTO.self, from: data)
                } catch {
                    completion(.failure(ServiceError.decodingError))
                    return
                }
                
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
                name: ProfileImageService.didChangeAvatarImageLinkNotification,
                object: self,
                userInfo: [Constants.notificationAvatarImageLinkKey: profileImageLink]
            )
    }
}

// MARK: - Constants

private extension ProfileImageService {
     enum Constants {
         static let didChangeAvatarImageLinkNotification = "ProfileImageProviderDidChange"
         static let notificationAvatarImageLinkKey = "avatarImageLink"
    }
}
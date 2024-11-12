//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 08.11.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService.create()
    
    private(set) var profile: Profile?
    
    private let oauth2Storage: OAuth2TokenStorageProtocol
    private let networkClient: NetworkRouting
    private var currentNetworkClientTask: URLSessionDataTask?
    
    private init(networkClient: NetworkRouting, oauth2Storage: OAuth2TokenStorageProtocol) {
        self.networkClient = networkClient
        self.oauth2Storage = oauth2Storage
    }
    
    static func create(
        networkClient: NetworkRouting = NetworkClient(),
        oauth2Storage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    ) -> ProfileService {
        return ProfileService(networkClient: networkClient, oauth2Storage: oauth2Storage)
    }
}

// MARK: - <ProfileServiceProtocol>

extension ProfileService: ProfileServiceProtocol {
    
    // NOTE: https://unsplash.com/documentation#get-the-users-profile
    
    func fetchProfile(completion: @escaping (Result<Profile, any Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard currentNetworkClientTask == nil else { return }

        guard let request = makeGetMyProfileRequest() else {
            let error = ServiceError.invalidURL
            print("[ProfileService/fetchProfile]: ServiceError ->", error.localizedDescription)
            completion(.failure(error))
            
            return
        }
        
        currentNetworkClientTask = networkClient
            .fetchObject(for: request) { [weak self] (result: Result<ProfileResponseDTO, Error>) in
                
            self?.currentNetworkClientTask = nil
            self?.profile = nil
            
            switch result {
            case .success(let response):
                let profile = Profile(
                    id: response.id,
                    username: response.username,
                    firstName: response.firstName ?? "",
                    lastName: response.lastName ?? "",
                    bio: response.bio ?? ""
                )
                self?.profile = profile
                
                completion(.success(profile))
                
            case .failure(let error):
                print("[ProfileService/fetchProfile]: NetworkError ->", error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private methods

private extension ProfileService {
    func makeGetMyProfileRequest() -> URLRequest? {
        guard let baseURL = URL(string: ProfileServiceConstants.baseURL) else {
            return nil
        }
        
        var components = URLComponents()
        components.path = ProfileServiceConstants.mePath
        
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
}

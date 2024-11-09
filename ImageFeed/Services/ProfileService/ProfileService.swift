//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 08.11.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private(set) var networkClient: NetworkRouting
    private let oauth2Storage = OAuth2TokenStorage()
    private var currentNetworkClientTask: URLSessionDataTask?
    
    private init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - <ProfileServiceProtocol>

extension ProfileService: ProfileServiceProtocol {
    
    // NOTE: https://unsplash.com/documentation#get-the-users-profile
    
    func fetchProfile(completion: @escaping (Result<Profile, any Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard currentNetworkClientTask == nil else { return }

        guard let request = makeGetMyProfileRequest() else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        currentNetworkClientTask = networkClient.fetch(request: request) { [weak self] result in
            self?.currentNetworkClientTask = nil
            
            switch result {
            case .success(let data):

//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Received JSON: \(jsonString)")
//                } else {
//                    print("Failed to convert data to string")
//                }
                    
                let response: ProfileResponseDTO
                
                do {
                    response = try JSONDecoder().decode(ProfileResponseDTO.self, from: data)
                } catch {
                    completion(.failure(ServiceError.decodingError))
                    return
                }
                
                let profile = Profile(
                    id: response.id,
                    username: response.username,
                    firstName: response.firstName ?? "",
                    lastName: response.lastName ?? "",
                    bio: response.bio ?? ""
                )
                
                completion(.success(profile))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private methods

private extension ProfileService {
    func makeGetMyProfileRequest() -> URLRequest? {
        guard let baseURL = URL(string: Constants.baseURL) else {
            return nil
        }
        
        var components = URLComponents()
        components.path = Constants.mePath
        
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

// MARK: - Constants

private extension ProfileService {
     enum Constants {
         static let baseURL = "https://api.unsplash.com"
         static let mePath = "/me"
    }
}

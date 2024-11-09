//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 08.11.2024.
//

protocol ProfileServiceProtocol {
    var networkClient: NetworkRouting { get }
    var profile: Profile? { get }

    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
}

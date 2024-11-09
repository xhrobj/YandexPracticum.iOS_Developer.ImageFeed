//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.11.2024.
//

import Foundation

protocol ProfileImageServiceProtocol {
    var networkClient: NetworkRouting { get }
    var profileImageLink: String? { get }

    func fetchProfileImageLink(username: String, completion: @escaping (Result<String, Error>) -> Void)
}

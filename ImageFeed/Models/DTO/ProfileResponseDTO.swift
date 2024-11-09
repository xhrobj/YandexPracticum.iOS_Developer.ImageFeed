//
//  ProfileResponseDTO.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 08.11.2024.
//

// NOTE: https://unsplash.com/documentation#get-the-users-profile

struct ProfileResponseDTO: Decodable {
    let id: String
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

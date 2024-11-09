//
//  UserResponseDTO.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.11.2024.
//

struct UserResponseDTO: Decodable {
    let profileImage: ProfileImageDTO

    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

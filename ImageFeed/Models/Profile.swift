//
//  Profile.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 08.11.2024.
//

struct Profile {
    let id: String
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    
    var fullName: String {
        let name = [firstName, lastName].filter { !$0.isEmpty }.joined(separator: " ")
        return name.isEmpty ? "😜" : name
    }
    
    var loginName: String {
        "@" + username
    }
}

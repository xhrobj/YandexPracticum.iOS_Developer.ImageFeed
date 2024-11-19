//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 17.11.2024.
//

import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func displayProfile(name: String, login: String, description: String)
    func displayAvatar(imageURL: URL)
    func showLogoutConfirmation()
}

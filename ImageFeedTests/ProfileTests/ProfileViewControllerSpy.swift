//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Mikhail Eliseev on 19.11.2024.
//

@testable import ImageFeed

import ImageFeed

import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var displayProfileCalled = false
    var displayProfileName: String?
    var displayProfileLogin: String?
    var displayProfileDescription: String?
    
    var displayAvatarCalled = false
    var displayAvatarURL: URL?
    
    var showLogoutConfirmationCalled = false
    
    func displayProfile(name: String, login: String, description: String) {
        displayProfileCalled = true
        displayProfileName = name
        displayProfileLogin = login
        displayProfileDescription = description
    }
    
    func displayAvatar(imageURL: URL) {
        displayAvatarCalled = true
        displayAvatarURL = imageURL
    }
    
    func showLogoutConfirmation() {
        showLogoutConfirmationCalled = true
    }
}

//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 17.11.2024.
//

import UIKit

final class ProfilePresenter {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    private var avatarImageURL: URL? {
        let imageLink = profileImageService.profileImageLink
        
        guard let imageLink else { return nil}
        
        return URL(string: imageLink)
    }
}

// MARK: - <ProfilePresenterProtocol>

extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        updateProfile()
    }
    
    func viewWillAppear() {
        addObservers()
    }
    
    func viewWillDisappear() {
        removeObservers()
    }

    func didLogoutButtonTap() {
        view?.showLogoutConfirmation()
    }
    
    func logout() {
        profileLogoutService.logout()
        showStartScreen()
    }
}

// MARK: - Private methods

private extension ProfilePresenter {
    func updateProfile() {
        guard let profile = profileService.profile else { return }
        
        view?.displayProfile(
            name: profile.fullName,
            login: profile.loginName,
            description: profile.bio
        )
        
        updateAvatar()
    }
    
    func updateAvatar() {
        guard let avatarImageURL = avatarImageURL else { return }
        
        view?.displayAvatar(imageURL: avatarImageURL)
    }
    
    func showStartScreen() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else {
            return
        }
        
        window.rootViewController = SplashViewController()
    }
}

// MARK: - Notifications

private extension ProfilePresenter {
    func addObservers() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateAvatar(notification:)),
                name: ProfileImageService.didChangeAvatarImageLinkNotification,
                object: nil
            )
    }

    func removeObservers() {
        NotificationCenter.default
            .removeObserver(
                self,
                name: ProfileImageService.didChangeAvatarImageLinkNotification,
                object: nil
            )
    }
}

// MARK: - @objc Actions

private extension ProfilePresenter {
    
    @objc
    func updateAvatar(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let profileImageLink = userInfo[ProfileImageService.notificationAvatarImageLinkKey] as? String,
            let avatarImageURL = URL(string: profileImageLink)
        else { return }
        
        view?.displayAvatar(imageURL: avatarImageURL)
    }
}

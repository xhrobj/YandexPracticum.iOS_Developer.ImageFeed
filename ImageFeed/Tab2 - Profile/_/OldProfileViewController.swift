//
//  OldProfileViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 17.11.2024.
//

//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 29.10.2024.
//

import UIKit
import Kingfisher

final class OldProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YP White")
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YP Gray")
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YP White")
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "logout") ?? UIImage(),
            target: self,
            action: #selector(logoutButtonTapped)
        )
        button.tintColor = UIColor(named: "YP Red")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var avatarImageURL: URL? {
        let imageLink = profileImageService.profileImageLink
        
        guard let imageLink else { return nil}
        
        return URL(string: imageLink)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureView(with: profileService.profile)
        updateAvatar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObservers()
    }
}

// MARK: - Private methods

private extension OldProfileViewController {
    func configureView(with profile: Profile?) {
        guard let profile else { return }
        
        nameLabel.text = profile.fullName
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func configureView() {
        view.backgroundColor = UIColor(named: "YP Black")
        
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
        
        setupAvatarImageView()
        setupNameLabel()
        setupLoginLabel()
        setupDescriptionLabel()
        setupExitButton()
        
        avatarImageView.image = UIImage(named: "profile_placeholder")
        nameLabel.text = ""
        loginLabel.text = ""
        descriptionLabel.text = ""
    }
    
    func setupAvatarImageView() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
    
    func setupNameLabel() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func setupLoginLabel() {
        NSLayoutConstraint.activate([
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func setupDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func setupExitButton() {
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -14),
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
    }
    
    func updateAvatar() {
        guard let avatarImageURL = avatarImageURL else { return }
        
        updateAvatar(with: avatarImageURL)
    }
    
    func updateAvatar(with imageURL: URL) {
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: imageURL)
    }
    
    func showAlert() {
        let alertController = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            self?.logout()
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func logout() {
        profileLogoutService.logout()
        showStartScreen()
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

// MARK: - @objc Actions

private extension OldProfileViewController {
    
    @objc
    func logoutButtonTapped() {
        showAlert()
    }
    
    @objc
    func updateAvatar(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let profileImageLink = userInfo[ProfileImageService.notificationAvatarImageLinkKey] as? String,
            let avatarImageURL = URL(string: profileImageLink)
        else { return }
        
        updateAvatar(with: avatarImageURL)
    }
}

// MARK: - Notifications

private extension OldProfileViewController {
    private func addObservers() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateAvatar(notification:)),
                name: ProfileImageService.didChangeAvatarImageLinkNotification,
                object: nil
            )
    }
       
    private func removeObservers() {
        NotificationCenter.default
            .removeObserver(
                self,
                name: ProfileImageService.didChangeAvatarImageLinkNotification,
                object: nil
            )
    }
}

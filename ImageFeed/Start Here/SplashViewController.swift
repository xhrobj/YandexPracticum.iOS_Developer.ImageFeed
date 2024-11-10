//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 06.11.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private let navigationAuthViewControllerStoryboardId = "AuthNavVCStoryboardID"
    private let tabBarControllerStoryboardId = "TabBarControllerStoryboardID"
    
    private let oauth2Storage = OAuth2TokenStorage.shared
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let logoImageView: UIImageView = {
        let image = UIImage(named: "practicum_logo_splash")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showNextScreen()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: - <AuthViewControllerDelegate>

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticateWithCode(_ code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            self.fetchOAuth2AccessToken(code)
        }
    }
}

// MARK: - Private methods

private extension SplashViewController {
    func showNextScreen() {
        print("(⌒‿⌒) saved token:", oauth2Storage.token as Any)
        
        guard oauth2Storage.token != nil else {
            showAuth()
            return
        }
        
        guard profileService.profile != nil else {
            fetchProfile()
            return
        }

        switchToTabBarController()
    }
    
    func showAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        guard let navigationController = storyboard.instantiateViewController(
            withIdentifier: navigationAuthViewControllerStoryboardId) as? UINavigationController,
              let authViewController = navigationController.viewControllers.first as? AuthViewController
        else {
            fatalError("(•_•) Invalid Configuration")
        }

        navigationController.modalPresentationStyle = .fullScreen
        authViewController.delegate = self
        
        present(navigationController, animated: true)
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("(•_•) Invalid Configuration")
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: tabBarControllerStoryboardId)
        window.rootViewController = tabBarController
    }
    
    func showAlert(for error: Error, _ methodDescription: String, retryHandler: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: "[\(methodDescription)] \(error.localizedDescription)",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "ОК", style: .default) { _ in
            retryHandler()
        })
        
        present(alertController, animated: true)
    }
}

// MARK: - Private methods - Load Data

private extension SplashViewController {
    func fetchOAuth2AccessToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuth2Token(for: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                self.oauth2Storage.token = token
                print("^_^ token received successfully:", token)
                self.showNextScreen()
                
            case .failure(let error):
                print(">_< Failed to fetch OAuth2 Token:", error.localizedDescription)
                self.showAlert(for: error, "Получение токена") { [weak self] in
                    self?.fetchOAuth2AccessToken(code)
                }
            }
        }
    }
    
    func fetchProfile() {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile() { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                print("^_^ profile received successfully:", profile)
                self.profileImageService.fetchProfileImageLink(username: profile.username) { _ in }
                self.showNextScreen()
                
            case .failure(let error):
                print(">_< Failed to fetch Profile:", error.localizedDescription)
                self.showAlert(for: error, "Получение профиля") { [weak self] in
                    self?.fetchProfile()
                }
            }
        }
    }
}

// MARK: - Private methods - Layout

private extension SplashViewController {
    func configureView() {
        view.backgroundColor = UIColor(named: "YP Black")
        view.addSubview(logoImageView)
        setupLogoImageView()
    }
    
    func setupLogoImageView() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
            logoImageView.heightAnchor.constraint(equalToConstant: 78),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

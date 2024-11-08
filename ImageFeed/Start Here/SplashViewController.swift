//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 06.11.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private let tabBarControllerId = "TabBarControllerId"
    private let showAuthSequeId = "ShowAuthSegue"
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2Storage = OAuth2TokenStorage()
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
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

// MARK: - Segue

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showAuthSequeId else {
            super.prepare(for: segue, sender: sender)
            return
        }

        guard
            let navigationController = segue.destination as? UINavigationController,
            let viewController = navigationController.viewControllers[0] as? AuthViewController
        else {
            assertionFailure("(•_•) Failed to prepare for \(segue.identifier ?? "¯∖_(ツ)_/¯")")
            return
        }
        
        viewController.delegate = self
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

        oauth2Storage.reset()
        switchToTabBarController()
    }
    
    func showAuth() {
        performSegue(withIdentifier: showAuthSequeId, sender: nil)
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: tabBarControllerId)
        window.rootViewController = tabBarController
    }
    
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
                print(">_<  Failed to fetch OAuth2 Token:", error.localizedDescription)
            }
        }
    }
}

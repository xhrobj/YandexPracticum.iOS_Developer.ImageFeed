//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 04.11.2024.
//

// NOTE: https://unsplash.com/documentation/user-authentication-workflow

import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewSequeId = "ShowWebViewSeque"
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2Storage = OAuth2TokenStorage()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBackButton()
    }
}

// MARK: - Segue

extension AuthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showWebViewSequeId else {
            super.prepare(for: segue, sender: sender)
            return
        }

        guard let viewController = segue.destination as? WebViewController else {
            assertionFailure("Failed to prepare for \(segue.identifier ?? "¯∖_(ツ)_/¯")")
            return
        }

        viewController.delegate = self
    }
}

// MARK: - <WebViewControllerDelegate>

extension AuthViewController: WebViewControllerDelegate {
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        print("(⌒‿⌒) saved token:", oauth2Storage.token as Any)
        fetchAccessToken(code)
    }

    func webViewControllerDidCancel(_ vc: WebViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Private methods

private extension AuthViewController {
    func configureNavBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    func fetchAccessToken(_ code: String) {
        oauth2Service.fetchOAuth2Token(for: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self.oauth2Storage.token = token
                    print("^_^ token received successfully:", token)
                case .failure(let error):
                    print(">_<  Failed to fetch OAuth2 Token:", error.localizedDescription)
                }
            }
        }
    }
}

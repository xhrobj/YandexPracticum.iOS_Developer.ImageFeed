//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 04.11.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    
    private let showWebViewSequeId = "ShowWebViewSeque"

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

        guard let webWiewController = segue.destination as? WebViewController else {
            assertionFailure("(•_•) Failed to prepare for \(segue.identifier ?? "¯∖_(ツ)_/¯")")
            return
        }
        
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        webViewPresenter.view = webWiewController
        
        webWiewController.presenter = webViewPresenter
        webWiewController.delegate = self
    }
}

// MARK: - <WebViewControllerDelegate>

extension AuthViewController: WebViewControllerDelegate {
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        delegate?.didAuthenticateWithCode(code)
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
}

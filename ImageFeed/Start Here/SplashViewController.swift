//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 06.11.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthSequeId = "ShowAuthSegue"
    
    // MARK: - View lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        sleep(2)
        showAuth()
    }
}

// MARK: - Private methods

private extension SplashViewController {
    func showAuth() {
        performSegue(withIdentifier: showAuthSequeId, sender: nil)
    }
}

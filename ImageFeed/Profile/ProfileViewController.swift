//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 29.10.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet private var avatarImageView: UIImageView!
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var exitButton: UIButton!
    
    // MARK: - @IBActions
    
    @IBAction private func exitButtonTapped() {
    }
    
}

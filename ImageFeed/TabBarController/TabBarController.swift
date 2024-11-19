//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 10.11.2024.
//

import UIKit
 
final class TabBarController: UITabBarController {
    private let imagesListViewControllerStoryboardId = "ImagesListVCStoryboardID"
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
}

// MARK: - Private methods

private extension TabBarController {
    func configure() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: imagesListViewControllerStoryboardId) as? ImagesListViewController
        else {
            assertionFailure("(•_•) Invalid Configuration")
            return
        }
        
        let imagesListPresenter = ImagesListPresenter()
        
        imagesListPresenter.view = imagesListViewController
        imagesListViewController.presenter = imagesListPresenter
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        
        profilePresenter.view = profileViewController
        profileViewController.presenter = profilePresenter

        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

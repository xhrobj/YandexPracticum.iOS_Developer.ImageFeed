//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 19.11.2024.
//

import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var viewWillAppearCalled = false
    var viewWillDisappearCalled = false
    var didLogoutButtonTapCalled = false
    var logoutCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func viewWillAppear() {
        viewWillAppearCalled = true
    }
    
    func viewWillDisappear() {
        viewWillDisappearCalled = true
    }
    
    func didLogoutButtonTap() {
        didLogoutButtonTapCalled = true
    }
    
    func logout() {
        logoutCalled = true
    }
}

//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Mikhail Eliseev on 19.11.2024.
//

@testable import ImageFeed

import XCTest

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        
        presenter.view = viewController
        viewController.presenter = presenter
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled, "Метод viewDidLoad() у презентера не был вызван")
    }
    
    func testViewControllerCallsDidLogoutButtonTap() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        
        presenter.view = viewController
        viewController.presenter = presenter
        
        // when
        viewController.logoutButtonTapped()
        
        // then
        XCTAssertTrue(presenter.didLogoutButtonTapCalled, "Метод didLogoutButtonTap() у презентера не был вызван")
    }
    
    func testViewControllerShowsLogoutConfirmation() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        
        presenter.view = viewController
        viewController.presenter = presenter
        
        // when
        presenter.didLogoutButtonTap()
        
        // then
        XCTAssertTrue(viewController.showLogoutConfirmationCalled, "Метод showLogoutConfirmation() у вью не был вызван")
    }
}

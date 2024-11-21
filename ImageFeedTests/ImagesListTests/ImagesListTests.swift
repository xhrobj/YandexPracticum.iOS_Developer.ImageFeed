//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Mikhail Eliseev on 19.11.2024.
//

@testable import ImageFeed

import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "ImagesListVCStoryboardID") as! ImagesListViewController
        
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled, "Метод viewDidLoad() у презентера не был вызван")
    }

    func testViewPresenterCallsShowSingleImage() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.photos = [ImageFeed.Photo.mock()]

        // when
        presenter.didPhotoTap(at: 0)

        // then
        XCTAssertTrue(viewController.showSingleImageCalled, "Метод showSingleImageCalled() у вью не был вызван")
    }
}

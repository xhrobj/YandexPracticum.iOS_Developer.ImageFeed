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
}

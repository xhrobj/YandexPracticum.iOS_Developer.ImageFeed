//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Mikhail Eliseev on 17.11.2024.
//

import ImageFeed

import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: ImageFeed.WebViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateLoadingProgressValue(_ value: Double) {}
    
    func code(from url: URL) -> String? {
        return nil
    }
}

//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Mikhail Eliseev on 17.11.2024.
//

import ImageFeed

import Foundation

final class WebViewControllerSpy: WebViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setLoadingProgressValue(_ value: Float) {}
    func setLoadingProgressHidden(_ isHidden: Bool) {}
}

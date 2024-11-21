//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 16.11.2024.
//

import Foundation

final class WebViewPresenter {
    weak var view: WebViewControllerProtocol?
    
    private var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
}

// MARK: - <WebViewPresenterProtocol>

extension WebViewPresenter: WebViewPresenterProtocol {
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else {
            assertionFailure("(•_•) Failed to create auth request")
            return
        }
        
        didUpdateLoadingProgressValue(0)
        view?.load(request: request)
    }
    
    func didUpdateLoadingProgressValue(_ value: Double) {
        let progressValue = Float(value)
        view?.setLoadingProgressValue(progressValue)
        
        let shouldHideProgress = shouldHideProgress(for: progressValue)
        view?.setLoadingProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}

// MARK: - Private methods

extension WebViewPresenter {
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

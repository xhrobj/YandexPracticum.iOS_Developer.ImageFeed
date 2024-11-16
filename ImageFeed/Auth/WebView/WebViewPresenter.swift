//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 16.11.2024.
//

import Foundation

final class WebViewPresenter {
    weak var view: WebViewControllerProtocol?
}

// MARK: - <WebViewPresenterProtocol>

extension WebViewPresenter: WebViewPresenterProtocol {
    func viewDidLoad() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeLink) else {
            assertionFailure(
                "(•_•) Failed to Failed to create URLComponents from string " +
                Constants.unsplashAuthorizeLink
            )
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AuthConfiguration.standard.accessKey),
            URLQueryItem(name: "redirect_uri", value: AuthConfiguration.standard.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AuthConfiguration.standard.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure(
                "(•_•) Failed to create URL from URLComponents with base URL " +
                (urlComponents.string ?? "¯∖_(ツ)_/¯")
            )
            return
        }
        
        let request = URLRequest(url: url)
        
        view?.load(request: request)
    }
    
    func didUpdateLoadingProgressValue(_ value: Double) {
        let progressValue = Float(value)
        view?.setLoadingProgressValue(progressValue)
        
        let shouldHideProgress = shouldHideProgress(for: progressValue)
        view?.setLoadingProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        guard
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        else {
            return nil
        }
        
        return codeItem.value
    }
}

// MARK: - Private methods

private extension WebViewPresenter {
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

// MARK: - Constants

private extension WebViewPresenter {
    enum Constants {
        static let unsplashAuthorizeLink = "https://unsplash.com/oauth/authorize"
    }
}

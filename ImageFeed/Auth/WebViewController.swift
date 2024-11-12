//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 04.11.2024.
//

import UIKit
@preconcurrency import WebKit

final class WebViewController: UIViewController {
    weak var delegate: WebViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - @IBOutlets
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var loadingProgressView: UIProgressView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
        loadAuthView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addObservers()
        updateLoadingProgress()
    }
}

// MARK: - <WKNavigationDelegate>

extension WebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - Private methods

private extension WebViewController {
    func configureWebView() {
        webView.navigationDelegate = self
    }
    
    func updateLoadingProgress() {
        loadingProgressView.progress = Float(webView.estimatedProgress)
        loadingProgressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            print("Error: Failed to create URLComponents from string", Constants.unsplashAuthorizeURLString)
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: OAuth2Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: OAuth2Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: OAuth2Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("Error: Failed to create URL from URLComponents with base URL", urlComponents.string ?? "¯∖_(ツ)_/¯")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        updateLoadingProgress()
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        guard
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let codeItem = urlComponents.queryItems?.first(where: { $0.name == "code" })
        else {
            return nil
        }
        
        return codeItem.value
    }
}

// MARK: - Notifications

private extension WebViewController {
    func addObservers() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 self?.updateLoadingProgress()
             }
        )
    }
}

// MARK: - Constants

private extension WebViewController {
     enum Constants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
}

//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 04.11.2024.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    weak var delegate: WebViewControllerDelegate?
    
    // MARK: - @IBOutlets
    
    @IBOutlet private var webView: WKWebView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
        loadAuthView()
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
    
    func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        }
        
        return nil
    }
}

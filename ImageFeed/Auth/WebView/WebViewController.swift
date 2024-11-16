//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 04.11.2024.
//

import UIKit
@preconcurrency import WebKit

final class WebViewController: UIViewController {
    var presenter: WebViewPresenterProtocol?
    
    weak var delegate: WebViewControllerDelegate?
    
    // MARK: - @IBOutlets
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var loadingProgressView: UIProgressView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
        configureLoadingProgressView()
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObservers()
    }
    
    // MARK: -
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard keyPath == #keyPath(WKWebView.estimatedProgress) else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        presenter?.didUpdateLoadingProgressValue(webView.estimatedProgress)
    }
}

// MARK: - <WebViewControllerProtocol>

extension WebViewController: WebViewControllerProtocol {
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setLoadingProgressValue(_ value: Float) {
        loadingProgressView.progress = value
    }
    
    func setLoadingProgressHidden(_ isHidden: Bool) {
        loadingProgressView.isHidden = isHidden
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
    
    func configureLoadingProgressView() {
        presenter?.didUpdateLoadingProgressValue(0)
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url else { return nil }
        
        return presenter?.code(from: url)
    }
}

// MARK: - Notifications

private extension WebViewController {
    func addObservers() {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    func removeObservers() {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
}

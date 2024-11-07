//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 04.11.2024.
//

protocol WebViewControllerDelegate: AnyObject {
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewControllerDidCancel(_ vc: WebViewController)
}

//
//  WebViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 16.11.2024.
//

import Foundation

protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    func load(request: URLRequest)
    func setLoadingProgressValue(_ value: Float)
    func setLoadingProgressHidden(_ isHidden: Bool)
}

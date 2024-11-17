//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 16.11.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didUpdateLoadingProgressValue(_ value: Double)
    func code(from url: URL) -> String?
}

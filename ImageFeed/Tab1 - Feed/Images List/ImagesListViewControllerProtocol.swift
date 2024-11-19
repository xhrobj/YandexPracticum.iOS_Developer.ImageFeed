//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 18.11.2024.
//

import Foundation

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func addPhotos(fromIndex: Int, toIndex: Int)
    func setIsLiked(for index: Int, isLiked: Bool)
    func showSingleImage(with imageURL: URL)
    func showAlert(for error: Error)
}

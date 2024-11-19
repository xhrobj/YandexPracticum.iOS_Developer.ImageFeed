//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Mikhail Eliseev on 19.11.2024.
//

import ImageFeed

import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?

    var addPhotosCalled = false
    var addedFromIndex: Int?
    var addedToIndex: Int?

    var setIsLikedCalled = false
    var setIsLikedIndex: Int?
    var setIsLikedValue: Bool?

    var showSingleImageCalled = false
    var shownImageURL: URL?

    var showAlertCalled = false
    var shownError: Error?

    func addPhotos(fromIndex: Int, toIndex: Int) {
        addPhotosCalled = true
        addedFromIndex = fromIndex
        addedToIndex = toIndex
    }

    func setIsLiked(for index: Int, isLiked: Bool) {
        setIsLikedCalled = true
        setIsLikedIndex = index
        setIsLikedValue = isLiked
    }

    func showSingleImage(with imageURL: URL) {
        showSingleImageCalled = true
        shownImageURL = imageURL
    }

    func showAlert(for error: Error) {
        showAlertCalled = true
        shownError = error
    }
}

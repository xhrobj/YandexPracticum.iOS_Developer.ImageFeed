//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Mikhail Eliseev on 19.11.2024.
//

import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?

    var numberOfPhotos: Int = 0

    var viewDidLoadCalled = false
    var viewWillAppearCalled = false
    var viewWillDisappearCalled = false
    var didReachEndOfFeedCalled = false
    var didPhotoTapIndex: Int?
    var didLikeTapIndex: Int?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func viewWillAppear() {
        viewWillAppearCalled = true
    }

    func viewWillDisappear() {
        viewWillDisappearCalled = true
    }

    func photo(at index: Int) -> ImageFeed.Photo? {
        return ImageFeed.Photo.mock()
    }

    func didReachEndOfFeed() {
        didReachEndOfFeedCalled = true
    }

    func didPhotoTap(at index: Int) {
        didPhotoTapIndex = index
    }

    func didLikeTap(at index: Int) {
        didLikeTapIndex = index
    }
}

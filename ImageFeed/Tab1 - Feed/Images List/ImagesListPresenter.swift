//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 18.11.2024.
//

import UIKit

final class ImagesListPresenter {
    weak var view: ImagesListViewControllerProtocol?
    
    var numberOfPhotos: Int {
        photos.count
    }
    
    private let showSingleImageSequeId = "ShowSingleImageSeque"
    
    private let imagesListService = ImagesListService.shared
    
    private var photos: [Photo] = []
}

// MARK: - <ImagesListPresenterProtocol>

extension ImagesListPresenter: ImagesListPresenterProtocol {
    func viewDidLoad() {
        startFetchFeed()
    }
    
    func viewWillAppear() {
        addObservers()
    }
    
    func viewWillDisappear() {
        removeObservers()
    }
    
    func photo(at index: Int) -> Photo? {
        guard index < numberOfPhotos else { return nil }
        
        return photos[index]
    }
    
    func didReachEndOfFeed() {
        fetchNextBatchOfPhotos()
    }
    
    func didPhotoTap(at index: Int) {
        guard
            let photo = photo(at: index),
            let imageURL = photo.largeImageURL
        else {
            return
        }
        
        view?.showSingleImage(with: imageURL)
    }

    func didLikeTap(at index: Int) {
        guard let photo = photo(at: index) else { return }
        
        changeLike(for: photo.id, isLiked: !photo.isLiked)
    }
}

// MARK: - Private methods

private extension ImagesListPresenter {
    func startFetchFeed() {
        fetchNextBatchOfPhotos()
    }
    
    func fetchNextBatchOfPhotos() {
        imagesListService.fetchPhotosNextPage()
    }

    func changeLike(for photoId: String, isLiked: Bool) {
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photoId, isLike: isLiked) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }

            switch result {
            case .success:
                guard let photoIndex = self.photos.firstIndex(where: { $0.id == photoId }) else {
                    return
                }

                let photo = self.photos[photoIndex]
                self.photos[photoIndex] = Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    welcomeDescription: photo.welcomeDescription,
                    tinyImageURL: photo.tinyImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: isLiked
                )

                self.view?.setIsLiked(for: photoIndex, isLiked: self.photos[photoIndex].isLiked)

            case .failure(let error):
                self.view?.showAlert(for: error)
            }
        }
    }
}

// MARK: - Notifications

private extension ImagesListPresenter {
    private func addObservers() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateTableViewAnimated),
                name: ImagesListService.didChangeNotification,
                object: nil
            )
    }
    
    private func removeObservers() {
        NotificationCenter.default
            .removeObserver(
                self,
                name: ImagesListService.didChangeNotification,
                object: nil
            )
    }
}

// MARK: - @objc Actions

private extension ImagesListPresenter {

    @objc
    func updateTableViewAnimated() {
        let previousCount = photos.count
        photos = imagesListService.photos
        let currentCount = photos.count

        guard previousCount != currentCount else { return }
        
        view?.addPhotos(fromIndex: previousCount, toIndex: currentCount - 1)
    }
}

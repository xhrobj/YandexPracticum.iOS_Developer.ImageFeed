//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.01.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let showSingleImageSequeId = "ShowSingleImageSeque"
    
    private let imagesListService = ImagesListService.shared
    
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    // MARK: - @IBOutlets

    @IBOutlet private var tableView: UITableView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        startFetchFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObservers()
    }
}

// MARK: - <UITableViewDataSource>

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configureCell(imageListCell, with: indexPath)
        
        return imageListCell
    }
}

// MARK: - <UITableViewDelegate>

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 >= imagesListService.photos.count else { return }
        
        fetchNextBatchOfPhotos()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var imageViewSize = CGSizeZero

        let photo = photo(for: indexPath)
        imageViewSize.height = photo.size.height
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        imageViewSize.width = tableView.bounds.width - (imageInsets.left + imageInsets.right)
        
        let scale = imageViewSize.width / photo.size.width
        imageViewSize.height = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return imageViewSize.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSequeId, sender: indexPath)
    }
}

// MARK: - Segue

extension ImagesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showSingleImageSequeId else {
            super.prepare(for: segue, sender: sender)
            return
        }

        guard
            let viewController = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath
        else {
            assertionFailure("(•_•) Failed to prepare for \(segue.identifier ?? "¯∖_(ツ)_/¯")")
            return
        }

        let photo = photo(for: indexPath)
        viewController.imageLink = photo.largeImageLink
    }
}

// MARK: - Private methods

private extension ImagesListViewController {
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func configureCell(_ cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photo(for: indexPath)
        
        cell.favoritesButton.setImage(UIImage(named: favoritesButtonImageName(for: indexPath)), for: .normal) // FIXME:

        if let photoCreatedAt = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: photoCreatedAt)
        } else {
            cell.dateLabel.text = ""
        }

        let placeholder = UIImage(named: "image_placeholder")
        
        cell.backgroundImageView.contentMode = .center
        cell.backgroundImageView.image = placeholder
        
        cell.backgroundImageView.kf.indicatorType = .activity
        cell.backgroundImageView.kf.setImage(
            with: URL(string: photo.tinyImageLink),
            placeholder: placeholder
        ) { [weak self] _ in
            guard let self = self else { return }
            
            cell.backgroundImageView.contentMode = .scaleAspectFill
            cell.backgroundImageView.kf.indicatorType = .none
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func favoritesButtonImageName(for indexPath: IndexPath) -> String {
        isFavorites(indexPath) ? "favorites_active" : "favorites"
    }
    
    func isFavorites(_ indexPath: IndexPath) -> Bool {
        indexPath.row % 2 == 0
    }
    
    func photo(for indexPath: IndexPath) -> Photo {
        ImagesListService.shared.photos[indexPath.row]
    }
    
    func startFetchFeed() {
        fetchNextBatchOfPhotos()
    }
    
    func fetchNextBatchOfPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
}

// MARK: - @objc Actions

private extension ImagesListViewController {

    @objc
    func updateFeed() {
        let previousCount = photos.count
        photos = imagesListService.photos
        let currentCount = photos.count

        guard previousCount != currentCount else { return }
        
        let indexPaths = (previousCount..<currentCount).map { IndexPath(row: $0, section: 0) }
        
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

// MARK: - Notifications

private extension ImagesListViewController {
    private func addObservers() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateFeed),
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

//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.01.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    var presenter: ImagesListPresenterProtocol?
    
    private let showSingleImageSequeId = "ShowSingleImageSeque"
    
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
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter?.viewWillDisappear()
    }
}

// MARK: - <ImagesListViewControllerProtocol>

extension ImagesListViewController: ImagesListViewControllerProtocol {
    func addPhotos(fromIndex: Int, toIndex: Int) {
        let indexPaths = (fromIndex...toIndex).map { IndexPath(row: $0, section: 0) }
        
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func setIsLiked(for index: Int, isLiked: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        
        cell.setIsLiked(isLiked)
    }
    
    func showSingleImage(with imageURL: URL) {
        performSegue(withIdentifier: showSingleImageSequeId, sender: imageURL)
    }
    
    func showAlert(for error: Error) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так(",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "ОК", style: .default))
        
        present(alertController, animated: true)
    }
}

// MARK: - <UITableViewDataSource>

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfPhotos ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        configureCell(imageListCell, with: indexPath)
        
        return imageListCell
    }
}

// MARK: - <UITableViewDelegate>

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let numberOfPhotos = presenter?.numberOfPhotos,
            indexPath.row + 1 >= numberOfPhotos
        else {
            return
        }
        
        let testMode = ProcessInfo.processInfo.arguments.contains("testMode")
        guard !testMode else {
            print("(•_•) test_mode is on, skipping fetching more photos")
            return
        }

        presenter?.didReachEndOfFeed()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = photo(for: indexPath) else { return 0 }
        
        var imageViewSize = CGSizeZero
        imageViewSize.height = photo.size.height
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        imageViewSize.width = tableView.bounds.width - (imageInsets.left + imageInsets.right)
        
        guard photo.size.width > 0 else { return 0 }
        
        let scale = imageViewSize.width / photo.size.width
        imageViewSize.height = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return imageViewSize.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didPhotoTap(at: indexPath.row)
    }
}

// MARK: - <ImagesListCellDelegate>

extension ImagesListViewController: ImagesListCellDelegate {
    func didTapLike(cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter?.didLikeTap(at: indexPath.row)
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
            let imageURL = sender as? URL
        else {
            assertionFailure("(•_•) Failed to prepare for \(segue.identifier ?? "¯∖_(ツ)_/¯")")
            return
        }

        viewController.imageURL = imageURL
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
        guard let photo = photo(for: indexPath) else { return }
        
        let dateText = photo.createdAt.flatMap { dateFormatter.string(from: $0) } ?? ""
        
        cell.configureCell(with: photo.tinyImageURL, dateText: dateText, isLiked: photo.isLiked)
    }
    
    func photo(for indexPath: IndexPath) -> Photo? {
        presenter?.photo(at: indexPath.row)
    }
}

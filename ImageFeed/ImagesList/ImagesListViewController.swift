//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.01.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    private let showSingleImageSequeId = "ShowSingleImageSeque"
    
    private let photosName: [String] = Array(0...19).map { String($0) }
    
    // MARK: - @IBOutlets

    @IBOutlet private var tableView: UITableView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
}

// MARK: - <UITableViewDataSource>

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var imageViewSize = CGSizeZero
        
        guard let image = UIImage(named: photoImageName(for: indexPath)) else {
            return imageViewSize.height
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        imageViewSize.width = tableView.bounds.width - (imageInsets.left + imageInsets.right)
        let scale = imageViewSize.width / image.size.width
        imageViewSize.height = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return imageViewSize.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSequeId, sender: indexPath)
    }
}

// MARK: -

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
            assertionFailure("Invalid segue destination")
            
            return
        }

        let image = UIImage(named: photosName[indexPath.row])
        viewController.image = image
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
        guard let image = UIImage(named: photoImageName(for: indexPath)) else { return }
        
        cell.configureCell(
            with: image,
            dateText: dateFormatter.string(from: Date()),
            favoritesButtonImageName: favoritesButtonImageName(for: indexPath)
        )
    }
    
    func favoritesButtonImageName(for indexPath: IndexPath) -> String {
        isFavorites(indexPath) ? "favorites_active" : "favorites"
    }
    
    func isFavorites(_ indexPath: IndexPath) -> Bool {
        indexPath.row % 2 == 0
    }
    
    func photoImageName(for indexPath: IndexPath) -> String {
        photosName[indexPath.row]
    }
}

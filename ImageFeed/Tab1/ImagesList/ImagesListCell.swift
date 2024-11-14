//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 11.01.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCellRID"
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - @IBOutlets
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var favoritesButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundImageView.kf.cancelDownloadTask()
    }
    
    // MARK: - @IBActions
    
    @IBAction private func favoritesButtonTapped() {
        delegate?.didTapLike(cell: self)
    }
}

// MARK: - Class API

extension ImagesListCell {
    func configureCell(with imageLink: String, dateText: String, isLiked: Bool) {
        dateLabel.text = dateText
        favoritesButton.setImage(UIImage(named: favoritesButtonImageName(for: isLiked)), for: .normal)
        
        let placeholder = UIImage(named: "image_placeholder")
        
        backgroundImageView.contentMode = .center
        backgroundImageView.image = placeholder
        
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(
            with: URL(string: imageLink),
            placeholder: placeholder
        ) { [weak self] _ in
            guard let self = self else { return }
            
            self.backgroundImageView.contentMode = .scaleAspectFill
            self.backgroundImageView.kf.indicatorType = .none
        }
    }
    
    func setIsLiked(_ isLiked: Bool) {
        favoritesButton.setImage(UIImage(named: favoritesButtonImageName(for: isLiked)), for: .normal)
    }
}

// MARK: - Private methods

private extension ImagesListCell {
    func favoritesButtonImageName(for isLiked: Bool) -> String {
        isLiked ? "favorites_active" : "favorites"
    }
}

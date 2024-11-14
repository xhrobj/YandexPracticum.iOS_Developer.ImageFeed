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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundImageView.kf.cancelDownloadTask()
    }
    
    // MARK: - @IBActions
    
    @IBAction private func favoritesButtonTapped() {
        delegate?.didTapLike(cell: self)
    }
}

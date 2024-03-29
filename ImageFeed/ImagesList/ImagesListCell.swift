//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 11.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCellRID"
    
    // MARK: - @IBOutlets
    
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var favoritesButton: UIButton!
}

// MARK: - Class API

extension ImagesListCell {
    func configureCell(with backgroundImage: UIImage, dateText: String, favoritesButtonImageName: String) {
        backgroundImageView.image = backgroundImage
        dateLabel.text = dateText
        favoritesButton.setImage(UIImage(named: favoritesButtonImageName), for: .normal)
    }
}

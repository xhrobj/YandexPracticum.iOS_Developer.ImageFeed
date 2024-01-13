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
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var favoritesButton: UIButton!
}

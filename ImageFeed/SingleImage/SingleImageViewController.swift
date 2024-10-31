//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 30.10.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage?
    
    // MARK: - @IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }    
}
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
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - @IBActions
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped() {
        guard let image else { return }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImageView()
        configureImageScrollView()
    }    
}

// MARK: - <UIScrollViewDelegate>

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: - Private methods

private extension SingleImageViewController {
    func configureImageView() {
        guard let image else { return }
        
        imageView.image = image
        imageView.frame.size = image.size
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    func configureImageScrollView() {
        imageScrollView.delegate = self
        
        imageScrollView.minimumZoomScale = 0.1
        imageScrollView.maximumZoomScale = 1.25
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = imageScrollView.minimumZoomScale
        let maxZoomScale = imageScrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = imageScrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        imageScrollView.setZoomScale(scale, animated: false)
        imageScrollView.layoutIfNeeded()
        
        let newContentSize = imageScrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        imageScrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

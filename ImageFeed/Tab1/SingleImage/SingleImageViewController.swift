//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 30.10.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var imageLink: String?
    
    // MARK: - @IBOutlets
    
    @IBOutlet private var imageScrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - @IBActions
    
    @IBAction private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func shareButtonTapped() {
        guard let image = imageView.image else { return }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureImageScrollView()
        configureImageView()
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
    func configureImageScrollView() {
        imageScrollView.delegate = self

        imageScrollView.minimumZoomScale = 0.1
        imageScrollView.maximumZoomScale = 1.25
    }
    
    func configureImageView() {
        guard let imageLink = self.imageLink else { return }
        
        let placeholder = UIImage(named: "image_placeholder")
        imageView.kf.setImage(with: URL(string: imageLink), placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            
            imageView.contentMode = .scaleAspectFit
            imageView.kf.indicatorType = .none
            
            guard let image = imageView.image else { return }
            
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = imageScrollView.minimumZoomScale
        let maxZoomScale = imageScrollView.maximumZoomScale

        let imageSize = image.size
        let visibleRectSize = imageScrollView.bounds.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))

        imageScrollView.setZoomScale(scale, animated: false)
        imageScrollView.layoutIfNeeded()

        let newContentSize = imageScrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2

        imageScrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

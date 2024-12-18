//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 30.10.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var imageURL: URL?
    
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
        
        loadAndDisplayImage()
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
    
    func configureImageViewWithPlaceholder() {
        let image = UIImage(named: "feed_image_placeholder") ?? UIImage()
        
        imageView.image = image
        imageView.contentMode = .center
        imageView.frame.size = image.size
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    func loadAndDisplayImage() {
        guard let imageURL = self.imageURL else {
            configureImageViewWithPlaceholder()
            
            return
        }
        
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let imageResult):
                self.imageView.contentMode = .scaleAspectFit
                self.imageView.frame.size = imageResult.image.size
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                self.configureImageViewWithPlaceholder()
                self.showAlert(for: error, false)
            }
        }
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let imageSize = image.size
        
        guard imageSize.width > 0, imageSize.height > 0 else { return }
        
        let visibleRectSize = imageScrollView.bounds.size
        let minZoomScale = imageScrollView.minimumZoomScale
        let maxZoomScale = imageScrollView.maximumZoomScale
        
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
    
    func showAlert(for error: Error, _ isDisplayError: Bool) {
        let message = "Попробовать ещё раз?" + (isDisplayError ? "\n\n" + error.localizedDescription : "")
        
        let alertController = UIAlertController(
            title: "Что-то пошло не так(",
            message: message,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Не надо", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadAndDisplayImage()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        
        present(alertController, animated: true)
    }
}

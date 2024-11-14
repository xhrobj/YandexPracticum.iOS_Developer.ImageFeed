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
    
    func configureImageView() {
        self.imageView.contentMode = .scaleAspectFit
    }
    
    func loadAndDisplayImage() {
        guard let imageLink = self.imageLink, let imageURL = URL(string: imageLink) else { return }
        
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let imageResult):
                self.imageView.frame.size = imageResult.image.size
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
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
    
    private func showError() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Попробовать ещё раз?",
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

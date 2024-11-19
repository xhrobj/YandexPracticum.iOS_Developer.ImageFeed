//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 18.11.2024.
//

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var numberOfPhotos: Int { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    
    func photo(at index: Int) -> Photo?

    func didReachEndOfFeed()
    func didPhotoTap(at index: Int)
    func didLikeTap(at index: Int)
}

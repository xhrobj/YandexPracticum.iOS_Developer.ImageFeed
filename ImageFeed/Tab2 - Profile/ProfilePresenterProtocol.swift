//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 17.11.2024.
//

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    
    func addObservers()
    func removeObservers()
    
    func didLogoutButtonTap()
    func logout()
}
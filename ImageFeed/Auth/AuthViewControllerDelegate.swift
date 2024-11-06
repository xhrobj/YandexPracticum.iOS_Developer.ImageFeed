//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 06.11.2024.
//

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticateWithCode(_ code: String)
}

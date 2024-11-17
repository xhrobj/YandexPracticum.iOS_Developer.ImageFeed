//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 16.11.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

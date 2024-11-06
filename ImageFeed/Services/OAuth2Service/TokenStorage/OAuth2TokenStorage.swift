//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 05.11.2024.
//

import Foundation

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    func reset() {
        Keys.allCases.forEach { key in
            userDefaults.removeObject(forKey: key.rawValue)
        }
    }
}

// MARK: - Keys

private extension OAuth2TokenStorage {
    enum Keys: String, CaseIterable {
        case token
    }
}

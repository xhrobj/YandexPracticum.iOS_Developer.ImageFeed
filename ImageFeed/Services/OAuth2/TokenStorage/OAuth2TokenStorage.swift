//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 05.11.2024.
//

import SwiftKeychainWrapper

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    static let shared = OAuth2TokenStorage()
    
    private let keychain = KeychainWrapper.standard
    
    private init() {}
    
    var token: String? {
        get {
            keychain.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let token = newValue else {
                keychain.removeObject(forKey: Keys.token.rawValue)
                return
            }
            
            keychain.set(token, forKey: Keys.token.rawValue)
        }
    }
    
    func reset() {
        Keys.allCases.forEach { key in
            keychain.removeObject(forKey: key.rawValue)
        }
    }
}

// MARK: - Keys

private extension OAuth2TokenStorage {
    enum Keys: String, CaseIterable {
        case token
    }
}

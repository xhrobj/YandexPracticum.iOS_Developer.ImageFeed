//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 14.11.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private let oauth2Storage = OAuth2TokenStorage.shared
    
    private init() {}
}

// MARK: - Class API

extension ProfileLogoutService {
    func logout() {
        oauth2Storage.reset()
        cleanCookies()
    }
}

// MARK: - Private methods

private extension ProfileLogoutService {
    func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

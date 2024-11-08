//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 08.11.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}

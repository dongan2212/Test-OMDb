//
//  UINavigationController+.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import UIKit

extension UINavigationController {
    var rootViewController: UIViewController? {
        return viewControllers.first
    }

    func changeBackGroundColor(bgColor: UIColor?) {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            if bgColor == nil || bgColor == .clear {
                appearance.configureWithTransparentBackground()
                appearance.shadowColor = .clear
                appearance.shadowImage = nil
            } else {
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = bgColor.ignoreNil()
            }

            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        } else {
            if bgColor == nil || bgColor == .clear {
                self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationBar.shadowImage = UIImage()
                self.navigationBar.isTranslucent = true
            } else {
                self.navigationBar.isTranslucent = false
                self.navigationBar.barTintColor = bgColor.ignoreNil()
            }
        }
    }
}

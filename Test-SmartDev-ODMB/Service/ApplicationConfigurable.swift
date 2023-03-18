//
//  ApplicationConfigurable.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import UIKit

protocol ApplicationConfigurable {
    func applicationRoute(from: UIWindow)
    func setRoot(window: UIWindow, view: UIViewController, isNavigation: Bool, animated: Bool)
}

extension ApplicationConfigurable {
    func setRoot(window: UIWindow, view: UIViewController, isNavigation: Bool = false, animated: Bool = true) {
        if animated {
            UIView.transition(with: window, duration: 0.22, options: .transitionFlipFromRight, animations: {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                if isNavigation {
                    let rootViewController = BaseNavigationController(rootViewController: view)
                    window.rootViewController = rootViewController
                } else {
                    window.rootViewController = view
                }
                UIView.setAnimationsEnabled(oldState)
            })
        } else {
            if isNavigation {
                let rootViewController = BaseNavigationController(rootViewController: view)
                window.rootViewController = rootViewController
            } else {
                window.rootViewController = view
            }
        }
    }
}

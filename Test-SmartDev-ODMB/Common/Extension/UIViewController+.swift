//
//  UIViewController+.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import UIKit

extension UIViewController {
    class func loadFromStoryboard<T>(storyboardType: Storyboard, bundle: Foundation.Bundle? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboardType.rawValue, bundle: bundle)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("\(storyboardType.rawValue) does not contain view controller with identifier \(String(describing: T.self))")
        }
        return viewController
    }
}

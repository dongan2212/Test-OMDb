//
//  Navigatable.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import UIKit

protocol Navigateable {
    var viewController: UIViewController? { get }
    func push(to viewController: UIViewController, animated: Bool)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func pop(to viewController: UIViewController, animated: Bool)
    func pop<T: UIViewController>(to viewController: T.Type)
    func popToRoot(animated: Bool)
    func dismissViewController(animated flag: Bool, completion: (() -> Void)?)
    func hideNavigationBar(animated: Bool)
    func showNavigationBar(bgColor: UIColor?, animated: Bool)
    func navigate(to destination: Destinating, present: Bool, animated flag: Bool, completion: (() -> Void)?)
}

// MARK: Default implement
extension Navigateable {
    func push(to viewController: UIViewController, animated: Bool = true) {
        self.viewController?.navigationController?.pushViewController(viewController, animated: animated)
    }

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.viewController?.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    func pop(to viewController: UIViewController, animated: Bool = true) {
        self.viewController?.navigationController?.popToViewController(viewController, animated: animated)
    }

    func popToRoot(animated: Bool = true) {
        self.viewController?.navigationController?.popToRootViewController(animated: animated)
    }

    func dismissViewController(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        self.viewController?.dismiss(animated: flag, completion: completion)
    }

    func hideNavigationBar(animated: Bool) {
        self.viewController?.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func showNavigationBar(bgColor: UIColor?, animated: Bool) {
        self.viewController?.navigationController?.changeBackGroundColor(bgColor: bgColor)
        self.viewController?.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension Navigateable where Self: UIViewController {
    var viewController: UIViewController? {
        return self
    }

    func navigate(to destination: Destinating,
                  present: Bool = false,
                  animated flag: Bool = true,
                  completion: (() -> Void)? = nil) {
        guard present else {
            push(to: destination.view, animated: flag)
            return
        }
        self.present(destination.view, animated: flag, completion: completion)
    }

    func pop<T: UIViewController>(to viewController: T.Type) {
        self.navigationController?
            .viewControllers
            .compactMap({ $0 })
            .forEach({ vc in
            if vc.isKind(of: viewController) {
                self.pop(to: vc, animated: true)
            }
        })
    }
}

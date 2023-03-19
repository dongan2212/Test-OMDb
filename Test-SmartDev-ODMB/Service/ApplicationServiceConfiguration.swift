//
//  ApplicationServiceConfiguration.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import UIKit

final class ApplicationServiceConfiguration: NSObject, ApplicationConfigurable {
    var window: UIWindow?

    override init() {
        super.init()
    }

    func applicationRoute(from window: UIWindow) {
        self.window = window
        let mainVM = MovieResultViewModel()
        let mainVC = MovieResultViewController(viewModel: mainVM)
        setRoot(window: window, view: mainVC)
    }
}

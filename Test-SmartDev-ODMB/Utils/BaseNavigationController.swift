//
//  BaseNavigationController.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.view.backgroundColor = .white
        changeBackGroundColor(bgColor: .white)
    }
}

extension BaseNavigationController: UINavigationControllerDelegate { }

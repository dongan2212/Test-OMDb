//
//  LoadingServiceableImplement.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation
import SVProgressHUD

class LoadingServiceableImplement: LoadingServiceable {
    func showLoading() {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
            SVProgressHUD.show(withStatus: "Please wait..")
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}

//
//  LoadingServiceableImplement.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import UIKit
import SnapKit

class LoadingServiceableImplement: LoadingServiceable {
    // MARK: - Properties
    private(set) var isAnimating: Bool = false

    // MARK: - Views
    private var keywindow: UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }

    lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.clear
        return backgroundView
    }()

    lazy var spinnerView: SpinnerView = {
        let spinnerView = SpinnerView()
        spinnerView.dynamicStrokeColor = UIColor.gray
        spinnerView.lineWidth = 4
        return spinnerView
    }()

    // MARK: - Init function
    init() {
        self.backgroundView.addSubview(self.spinnerView)
        self.spinnerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40.0)
        }
    }

    // MARK: - Public functions
    func showLoading() {
        isAnimating = true
        DispatchQueue.main.async {
            self.keywindow?.addSubview(self.backgroundView)
            self.keywindow?.bringSubviewToFront(self.backgroundView)
            self.spinnerView.animate()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.spinnerView.stopAnimate()
            self.backgroundView.removeFromSuperview()
            self.isAnimating = false
        }
    }
}

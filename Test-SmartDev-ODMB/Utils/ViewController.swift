//
//  ViewController.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController, Navigateable {
    // MARK: - Properties
    let disposeBag = DisposeBag()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindingData()
        makeUI()
        setupAction()
    }

    deinit {
        Logger.info("deinit: \(self)")
        NotificationCenter.default.removeObserver(self)
    }

    func setup() { }

    func bindingData() { }

    func makeUI() { }

    func setupAction() { }

    // TODO: Implement it later
    func handleError(error: Error) {
        
    }

    @objc func swipeRight(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            debugPrint("Swiped right!")
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension Reactive where Base: ViewController {
    var appError: Binder<Error> {
        return Binder(base) { base, appError in
            base.handleError(error: appError)
        }
    }
}

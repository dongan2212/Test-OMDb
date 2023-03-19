//
//  UITextField+.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import UIKit
import RxSwift
import RxCocoa

extension UITextField {
    func driver() -> Driver<String> {
        return rx.text.orEmpty.asDriver()
    }

    func value() -> Driver<String> {
        let text = rx.observe(String.self, "text").map({ $0 ?? "" }).asDriverOnErrorJustComplete()
        return Driver.merge(driver(), text).distinctUntilChanged()
    }

    func onChange() -> Driver<String> {
        let event = rx.controlEvent(.editingChanged).asDriver()
        return Driver.combineLatest(driver(), event).map({ $0.0 })
    }
}

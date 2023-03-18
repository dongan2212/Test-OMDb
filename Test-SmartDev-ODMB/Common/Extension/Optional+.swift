//
//  Optional+.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import UIKit

extension Optional {
    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }
}

extension Optional where Wrapped == String {
    func ignoreNil() -> String {
        self ?? ""
    }

    func withDefaultDash() -> String {
        self.ignoreNil().isEmpty ? "-" : self.ignoreNil()
    }
}

extension Optional where Wrapped == Int {
    func ignoreNil() -> Int {
        self ?? 0
    }
}

extension Optional where Wrapped == Double {
    func ignoreNil() -> Double {
        self ?? 0.0
    }
}

extension Optional where Wrapped == Bool {
    func ignoreNil() -> Bool {
        self ?? false
    }
}

extension Optional where Wrapped == UIColor {
    func ignoreNil() -> UIColor {
        self ?? UIColor.black
    }
}

extension Optional where Wrapped == UIImage {
    func ignoreNil() -> UIImage {
        self ?? .init()
    }
}

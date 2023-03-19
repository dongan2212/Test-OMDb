//
//  Array+.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        guard 0 <= index && index < count else { return nil }
        return self[index]
    }

    subscript (safe range: Range<Int>) -> [Element] {
        var result = [Element]()
        for index in range {
            if index < count {
                if let unwrapped = self[safe: index] {
                    result.append(unwrapped)
                } else {
                    continue
                }
            } else {
                break
            }
        }
        return result
    }

    func ignoreNil<T>() -> [T] where Element == T? {
        let nonNils = self.compactMap { $0 }
        return nonNils
    }
}

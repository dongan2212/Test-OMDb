//
//  APIConfigable.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

struct DebuggerConfig {
    var enableLog: Bool = false
    static let none = DebuggerConfig(enableLog: false)
    static let full = DebuggerConfig(enableLog: true)
}

protocol APIConfigable {
    var host: String { get set }
    var debugger: DebuggerConfig { get set }
}

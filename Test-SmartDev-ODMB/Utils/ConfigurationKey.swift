//
//  ConfigurationKey.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation

enum ConfigurationKey: String {
    case baseURL = "BASE_URL"

    func value() -> String? {
        return (Bundle.main.infoDictionary?[self.rawValue] as? String)?.replacingOccurrences(of: "\\", with: "")
    }
}

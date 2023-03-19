//
//  APIConfigure.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

class APIConfigure: APIConfigable {
    var debugger: DebuggerConfig = .full
    var host: String = ConfigurationKey.baseURL.value().ignoreNil() + "?apikey=\(Constant.API_KEY)"

    static var defaultHeader: [String: String] {
        let headers: [String: String] = ["Content-Type": "application/json"]
        return headers
    }
}

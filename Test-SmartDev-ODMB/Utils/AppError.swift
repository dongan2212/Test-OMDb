//
//  AppError.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

struct AppError: Codable, Error {
    var errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case errorMessage = "Error"
    }
    
    static let undefinedError: AppError = AppError(errorMessage: "Unknown error")
}

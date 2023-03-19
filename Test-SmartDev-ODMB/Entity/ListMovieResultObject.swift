//
//  ListMovieResultObject.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation

struct ListMovieObject: Codable {
    var search: [MovieObject]?
    var totalResults: String?
    var response: String?
    var error: String?

    enum CodingKeys: String, CodingKey {
        case totalResults
        case search = "Search"
        case response = "Response"
        case error = "Error"
    }
}

//
//  SearchMovieInput.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation

final class SearchMovieInput: APIInputable {
    var requestType: APIRequestType = .get
    var pathToApi: String = ""

    init(title: String, type: ImdbType?, page: Int?) {
        let keywordAddingPercentEncoding = title
            .addingPercentEncoding(withAllowedCharacters: .illegalCharacters)
            .ignoreNil()
        pathToApi += "&s=\(keywordAddingPercentEncoding)"
        if let type = type {
            pathToApi += "&type=\(type.rawValue)"
        }
        if let page = page {
            pathToApi += "&page=\(page)"
        }
    }

    func makeRequestableBody() -> [String: Any] {
        return [:]
    }

    func makeRequestableHeader() -> [String: String] {
        return APIConfigure.defaultHeader
    }
}

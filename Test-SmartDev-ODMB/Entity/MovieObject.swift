//
//  MovieObject.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation

enum ImdbType: String {
    case movie, series, episode, undefined
}

struct MovieObject: Codable {
    var title: String?
    var imdbID: Int?
    var year: Int?
    var type: String?
    var poster: String?

    enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}

extension MovieObject {
    func transform() -> Movie {
        var imdbType: ImdbType
        switch self.type?.lowercased() {
        case "movie":
            imdbType = .movie
        case "series":
            imdbType = .series
        case "episode":
            imdbType = .episode
        default:
            imdbType = .undefined
        }
        return Movie(
            title: self.title,
            imdbID: self.imdbID,
            year: self.year,
            type: imdbType,
            poster: self.poster
        )
    }
}

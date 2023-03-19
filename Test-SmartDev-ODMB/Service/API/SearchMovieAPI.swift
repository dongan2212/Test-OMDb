//
//  SearchMovieAPI.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation

final class SearchMovieAPI: APIRequestable {
    var input: SearchMovieInput
    var output: SearchMovieOutput

    init(input: SearchMovieInput,
         output: SearchMovieOutput) {
        self.input = input
        self.output = output
    }

    func getOutput() -> SearchMovieOutput? {
        self.output
    }
}


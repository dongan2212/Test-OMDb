//
//  SearchMovieOutput.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation

class SearchMovieOutput: APIOutputable {
  var result: ListMovieObject?
  var error: AppError?
  var responseParser: Parseable = CodeableParser<ResultType>()
  var errorParser: Parseable = CodeableParser<ErrorType>()
  var systemError: Error?
}

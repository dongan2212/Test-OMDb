//
//  MovieService.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieServiceable {
    func searchMovie(by title: String?,
                     type: ImdbType?,
                     and page: Int?,
                     completion: @escaping (_ results: ListMovieObject?,
                                            _ error: Error?) -> Void)
}

final class MovieServiceImplement: MovieServiceable {

    var networkProvider: NetworkProviable? {
        return ServiceFacade.getService(NetworkProviable.self)
    }

    func searchMovie(by title: String?,
                     type: ImdbType?,
                     and page: Int?,
                     completion: @escaping (_ results: ListMovieObject?,
                                            _ error: Error?) -> Void) {
        guard let apiService = networkProvider,
            let title = title else { return }
        let input = SearchMovieInput(title: title, type: type, page: page)
        let output = SearchMovieOutput()
        let request = SearchMovieAPI(input: input, output: output)

        apiService.load(api: request, onComplete: { (request) in
            guard let output = request.getOutput() else {
                completion(nil, nil)
                return
            }
            guard let result = output.result else { return }
            completion(result, nil)
        }, onRequestError: { request in
            completion(nil, request.output.error)
        }, onServerError: { error in
            completion(nil, error as? AppError)
        })
    }
}


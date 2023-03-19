//
//  MovieUseCase.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieUseCaseable {
    func searchMovie(by request: SearchMovieRequest) -> Observable<Result<[Movie?]?, Error>>
}

class MovieUseCaseableImplement: BaseUseCaseable, MovieUseCaseable {
    func searchMovie(by request: SearchMovieRequest) -> Observable<Result<[Movie?]?, Error>> {
        return .create { signal -> Disposable in
            self.movieService.searchMovie(by: request) { result, error in
                if let error = error {
                    signal.onNext(.failure(error))
                } else if let result = result {
                    if result.response.ignoreNil().lowercased() == "true" {
                        let movies: [Movie] = result.search?.compactMap({ $0.transform() }) ?? []
                        signal.onNext(.success(movies))
                    } else {
                        let appError: AppError = AppError(errorMessage: result.error.ignoreNil())
                        signal.onNext(.failure(appError))
                    }
                } else {
                    signal.onNext(.success([]))
                }
                signal.onCompleted()
            }
            return Disposables.create()
        }
    }
}

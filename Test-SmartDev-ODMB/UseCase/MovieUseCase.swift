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
    func searchMovie(
        by title: String?,
        type: ImdbType?,
        and page: Int?
    ) -> Observable<Result<[Movie], Error>>
}

class MovieUseCaseableImplement: BaseUseCaseable, MovieUseCaseable {
    func searchMovie(
        by title: String?,
        type: ImdbType?,
        and page: Int?
    ) -> Observable<Result<[Movie], Error>> {
        return .create { signal -> Disposable in
            self.movieService.searchMovie(by: title, type: type, and: page) { result, error in
                if let error = error {
                    signal.onNext(.failure(error))
                } else if let result = result {
                    if result.response == true {
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

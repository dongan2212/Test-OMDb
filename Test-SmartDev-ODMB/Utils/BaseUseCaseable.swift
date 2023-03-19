//
//  BaseUseCaseable.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation
import RxSwift

class BaseUseCaseable {
    var movieService: MovieServiceable

    init() {
        self.movieService = MovieServiceImplement()
    }

    func responseResultSuccess(signal: AnyObserver<Result<Bool?, AppError>>,
                               result: Bool?,
                               error: AppError?) {
        guard error == nil else {
            signal.onNext(.failure(error!))
            return
        }

        signal.onNext(.success(result))
        signal.onCompleted()
    }
}


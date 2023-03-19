//
//  MovieResultViewModel.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import Foundation
import RxCocoa
import RxSwift

class MovieResultViewModel: ViewModel {
    private let movieUseCase: MovieUseCaseable = MovieUseCaseableImplement()

    private var emptyRelay = BehaviorRelay<Bool>(value: false)
    private var moviesRelay = BehaviorRelay<[Movie?]>(value: [])
    private var currentPage: Int = 1
    private let firstPage: Int = 1
    private var isLastPage: Bool = true

    override init() {
        super.init()
    }
}

extension MovieResultViewModel: ViewModelTransformable {
    struct Input {
        let loadTrigger: Driver<Void>
//        let loadMoreTrigger: Driver<Void>
        let searchTextTrigger: Driver<String>
        let submitSearchAction: Driver<Void>
        let tapOnSearchButtonAction: Driver<Void>
    }

    struct Output {
        let loading: Driver<Bool>
        let appError: Driver<Error>
        let isEmpty: Driver<Bool>
        let movies: Driver<[Movie?]>
    }

    func transform(input: Input) -> Output {
        let searchText = input.searchTextTrigger
        handleSearchMovieResult(input: input, searchText: searchText)
        let moviesDriver = moviesRelay.asDriver()

        return Output(loading: activity.asDriver(),
                      appError: appError.asDriverOnErrorJustComplete(),
                      isEmpty: emptyRelay.asDriver(),
                      movies: moviesDriver)
    }
}

private extension MovieResultViewModel {
    func createSearchMovieRequest(title: String, page: Int) -> SearchMovieRequest {
        SearchMovieRequest(title: title, type: .movie, page: page)
    }

    func updateMovieList(_ value: [Movie?]?) {
        self.emptyRelay.accept(value?.isEmpty ?? false)
        let unwrappedValue = value ?? []
        let currentValue = self.moviesRelay.value
        let newValue = currentValue + unwrappedValue
        if let value = value, !value.isEmpty {
            self.moviesRelay.accept(newValue)
        }
    }

    func handleSearchMovieResult(input: Input, searchText: Driver<String>) {
        Driver.merge(input.submitSearchAction, input.tapOnSearchButtonAction)
            .withLatestFrom(searchText)
            .distinctUntilChanged({ oldValue, newValue in
            return oldValue == newValue
        })
            .flatMapLatest { title -> Driver<Result<[Movie?]?, Error>> in
            let request = self.createSearchMovieRequest(title: title, page: self.currentPage)
            return self.movieUseCase.searchMovie(by: request)
                .trackActivity(self.activity)
                .asDriverOnErrorJustComplete()
        }
            .drive(onNext: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let result):
                self.updateMovieList(result)

            case .failure(let error):
                self.appError.onNext(error)
            }
        }).disposed(by: disposeBag)
    }
}

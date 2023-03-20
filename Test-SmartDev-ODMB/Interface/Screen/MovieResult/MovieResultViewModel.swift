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
    private var scrollToTopActionRelay = PublishRelay<Void>()
    private let firstPage: Int = 1
    private var currentPage: Int = 1
    private(set) var canLoadMore: Bool = false
    var resetSearchActionRelay = PublishRelay<Void>()

    override init() {
        super.init()
    }
}

extension MovieResultViewModel: ViewModelTransformable {
    struct Input {
        let loadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let inSearchTrigger: Driver<String>
        let searchTextTrigger: Driver<String>
        let submitSearchAction: Driver<Void>
        let tapOnSearchButtonAction: Driver<Void>
    }

    struct Output {
        let loading: Driver<Bool>
        let appError: Driver<Error>
        let isEmpty: Driver<Bool>
        let movies: Driver<[Movie?]>
        let scrollToTop: Driver<Void>
        let resetSearch: Driver<Void>
    }

    func transform(input: Input) -> Output {
        let searchText = input.searchTextTrigger
        handleSearchMovieResult(input: input, searchText: searchText)
        handleLoadMore(input: input, searchText: searchText)
        handleResetSearch(input: input)
        let moviesDriver = moviesRelay.asDriver()
        return Output(loading: activity.asDriver(),
                      appError: appError.asDriverOnErrorJustComplete(),
                      isEmpty: emptyRelay.asDriver(),
                      movies: moviesDriver,
                      scrollToTop: scrollToTopActionRelay.asDriverOnErrorJustComplete(),
                      resetSearch: resetSearchActionRelay.asDriverOnErrorJustComplete()
        )
    }
}

private extension MovieResultViewModel {
    func createSearchMovieRequest(title: String, page: Int) -> SearchMovieRequest {
        SearchMovieRequest(title: title, type: .movie, page: page)
    }

    func initialize(movies value: [Movie?]?, totalResult: Int) {
        self.emptyRelay.accept(value?.isEmpty ?? false)
        self.canLoadMore = (value?.count ?? 0) < totalResult
        if let value = value {
            self.currentPage = 1
            self.moviesRelay.accept(value)
            self.scrollToTopActionRelay.accept(())
        } else {
            self.moviesRelay.accept([])
        }
    }

    func update(movies value: [Movie?]?, totalResult: Int) {
        if let value = value {
            self.currentPage += 1
            let currentMovies = moviesRelay.value
            let newMovies = currentMovies + value
            self.moviesRelay.accept(newMovies)
            self.canLoadMore = newMovies.count < totalResult
        }
    }

    func handleResetSearch(input: Input) {
        input.inSearchTrigger
            .drive(onNext: { [weak self] _ in
            self?.resetSearchActionRelay.accept(())
        }).disposed(by: disposeBag)
    }

    func handleSearchMovieResult(input: Input, searchText: Driver<String>) {
        Driver.merge(input.submitSearchAction, input.tapOnSearchButtonAction)
            .withLatestFrom(searchText)
            .debounce(.milliseconds(150))
            .flatMapLatest { title -> Driver<Result<MoviesResponse, Error>> in
            let request = self.createSearchMovieRequest(title: title, page: self.firstPage)
            return self.movieUseCase.searchMovie(by: request)
                .trackActivity(self.activity)
                .asDriverOnErrorJustComplete()
        }
            .drive(onNext: { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let movieList = result.movies ?? []
                self.initialize(movies: movieList, totalResult: result.totalResults.ignoreNil())

            case .failure(let error):
                if let appError = error as? AppError {
                    self.appError.onNext(appError)
                } else {
                    self.appError.onNext(error)
                }
                self.emptyRelay.accept(true)
            }
        }).disposed(by: disposeBag)
    }

    func handleLoadMore(input: Input, searchText: Driver<String>) {
        input.loadMoreTrigger
            .filter({ self.canLoadMore })
            .withLatestFrom(searchText)
            .debounce(.milliseconds(150))
            .flatMapLatest { title -> Driver<Result<MoviesResponse, Error>> in
            let request = self.createSearchMovieRequest(title: title, page: self.currentPage + 1)
            return self.movieUseCase.searchMovie(by: request)
                .trackActivity(self.activity)
                .asDriverOnErrorJustComplete()
        }
            .drive(onNext: { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let movieList = result.movies ?? []
                self.update(movies: movieList, totalResult: result.totalResults.ignoreNil())

            case .failure(let error):
                if let appError = error as? AppError {
                    self.appError.onNext(appError)
                } else {
                    self.appError.onNext(error)
                }
            }
        }).disposed(by: disposeBag)
    }
}

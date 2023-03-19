//
//  ActivityIndicator.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation
import RxCocoa
import RxSwift

private struct ActivityToken<E>: ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable

    init(source: Observable<E>, disposeAction: @escaping () -> Void) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }

    func dispose() {
        _dispose.dispose()
    }

    func asObservable() -> Observable<E> {
        return _source
    }
}

/**
 Enables monitoring of sequence computation.
 
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
class ActivityIndicator: SharedSequenceConvertibleType {
    typealias Element = Bool

    typealias SharingStrategy = DriverSharingStrategy

    private let _lock = NSRecursiveLock()
    private let _variable = BehaviorRelay(value: 0)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    private let loadingIndicator = ServiceFacade.getService(LoadingServiceable.self)

    init() {
        _loading = _variable.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        loadingIndicator?.showLoading()
        return Observable.using({ () -> ActivityToken<O.Element> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }, observableFactory: { result in
            return result.asObservable()
                .do(onNext: { [weak self] _ in
                self?.loadingIndicator?.hideLoading()
            }, onError: { [weak self] _ in
                self?.loadingIndicator?.hideLoading()
            }, onCompleted: { [weak self] in
                self?.loadingIndicator?.hideLoading()
            })
        })
    }

    private func increment() {
        _lock.lock()
        _variable.accept(_variable.value + 1)
        _lock.unlock()
    }

    private func decrement() {
        _lock.lock()
        _variable.accept(_variable.value - 1)
        _lock.unlock()
    }

    func asSharedSequence() -> SharedSequence<DriverSharingStrategy, ActivityIndicator.Element> {
        return _loading
    }
}

extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
    func trackActivity(_ activityIndictor: ActivityIndicator, condition: Bool) -> Observable<Element> {
        guard condition else {
            return self.asObservable()
        }
        return activityIndictor.trackActivityOfObservable(self)
    }
}

//
//  ViewModel.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation
import RxSwift

public protocol ViewModelTransformable: AnyObject {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

class ViewModel: NSObject {
    internal var disposeBag: DisposeBag!
    internal var appError = PublishSubject<Error>()
    internal var activity = ActivityIndicator()

    override public init() {
        disposeBag = DisposeBag()
        super.init()
    }

    deinit {
        Logger.info("deinit: \(self)")
    }
}

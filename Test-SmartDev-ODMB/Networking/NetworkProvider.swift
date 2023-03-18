//
//  NetworkProvider.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

public protocol NetworkProviable {
    var observeHeaderStatusCode: ((Int, Error?, Any?) -> Void)? { get set }
    init(with config: APIConfigable, and requester: RequesterProviable?)
    func load<T: APIRequestable>(api: T,
                                 onComplete: @escaping (T) -> Void,
                                 onRequestError: @escaping (T) -> Void,
                                 onServerError: @escaping (Error?) -> Void)
}

public class NetworkProvider: NetworkProviable {
    private var config: APIConfigable
    private var requester: RequesterProviable
    public var observeHeaderStatusCode: ((Int, Error?, Any?) -> Void)?
    public required init(with config: APIConfigable,
                         and requester: RequesterProviable? = nil) {
        self.config = config
        self.requester = requester ?? AlamofireRequesterProvider()
        Logger.info("""
            \n--------------*****---------------------------------
            Starting Api service
            ||    - API host: \(self.config.host)
            ||    - Requester: \(type(of: self.requester))
            --------------*****---------------------------------
            """)
    }

    public func load<T: APIRequestable>(api: T,
                                        onComplete: @escaping (T) -> Void,
                                        onRequestError: @escaping (T) -> Void,
                                        onServerError: @escaping (Error?) -> Void) {
        Logger.warning("API will call: \(type(of: api.input))")
        Logger.info("API body: \(api.input.makeRequestableBody())")
        api.excute(with: self.config,
                   and: self.requester) { [weak self] _, _, statusCode in
            guard let self = self else { return }
            if api.output.hasError() {
                // TODOs: refactor this logic
                if api.output.errorServerInfomation != nil {
                    onServerError(api.output.errorServerInfomation)
                    if api.input.shouldBroadcastStatusCode() {
                        self.broadcast(statusCode,
                                       request: api.output.errorServerInfomation,
                                       api: nil)
                    }
                } else {
                    self.broadcast(statusCode,
                                   request: nil,
                                   api: api)
                    onRequestError(api)
                }
            } else {
                onComplete(api)
            }
        }
    }

    private func broadcast(_ statusCode: Int, request: Error?, api: Any?) {
        if let concreteDelegate = self.observeHeaderStatusCode {
            concreteDelegate(statusCode, request, api)
        }
    }
}

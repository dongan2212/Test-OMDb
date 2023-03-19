//
//  APIRequestable.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

typealias APIResponse = (data: Data?, error: Error?, statusCode: Int?)
protocol APIRequestable {
    associatedtype OutputType: APIOutputable
    associatedtype InputType: APIInputable
    var input: InputType { get }
    var output: OutputType { get set }
    func excute(with config: APIConfigable,
                and requester: RequesterProviable,
                complete: @escaping (APIResponse) -> Void)
    func getOutput() -> OutputType?
}

extension APIRequestable {
    func excute(with config: APIConfigable,
                and requester: RequesterProviable,
                complete: @escaping (APIResponse) -> Void) {
        let fullPathToApi = input.makeFullPathToApi(with: config)
        Logger.info("DEBUG - URL request: \(fullPathToApi)")
        Logger.info("DEBUG - Request Type: \(input.requestType)")
        self.logRequestInfo(with: fullPathToApi)
        if input.getBodyEncode() == .json {
            requester.makeRequest(path: fullPathToApi,
                                  requestType: input.requestType,
                                  headers: input.makeRequestableHeader(),
                                  params: input.makeRequestableBody()) { response in
                self.updateResultForOutput(from: response)
                complete(response)
            }
        } else {
            requester.makeFormDataRequest(path: fullPathToApi,
                                          requestType: input.requestType,
                                          headers: input.makeRequestableHeader(),
                                          params: input.makeRequestableBody()) { response in
                self.updateResultForOutput(from: response)
                complete(response)
            }
        }
    }
}

private extension APIRequestable {
    func updateResultForOutput(from response: APIResponse) {
        if let data = response.data,
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            Logger.verbose("""
              \n----------------------RAW JSON----------------------
              \(json)
              ----------------------********----------------------
              """)
        }

        if hasError(statusCode: response.statusCode) {
            self.output.convertError(from: response.data,
                                     systemError: response.error)
        } else {
            self.output.convertData(from: response.data)
        }
    }

    func hasError(statusCode: Int?) -> Bool {
        guard let statusCode = statusCode else {
            return true
        }
        return (statusCode < 200 || statusCode > 299)
    }

    func logRequestInfo(with path: String) {
        Logger.warning("API full api: \(path)")
        Logger.verbose("[\(type(of: self.input))][Type]: HTTP.\(self.input.requestType)")
        Logger.verbose("[\(type(of: self.input))][Param]: \(self.input.makeRequestableBody())")
        Logger.verbose("[\(type(of: self.input))][Encode]: \(input.getBodyEncode())")
    }
}

//
//  APIRequestable.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

public typealias APIResponse = (data: Data?, error: Error?, statusCode: Int)
public protocol APIRequestable {
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
  public func excute(with config: APIConfigable,
                     and requester: RequesterProviable,
                     complete: @escaping (APIResponse) -> Void) {
    let fullPathToApi = input.makeFullPathToApi(with: config)
    print("DEBUG - URL request: \(fullPathToApi)")
    print("DEBUG - Request Type: \(input.requestType)")
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

extension APIRequestable {
  private func updateResultForOutput(from response: APIResponse) {
    if let data = response.data,
       let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
      NetworkingLogger.write(log: """
              \n----------------------RAW JSON----------------------
              \(json)
              ----------------------********----------------------
              """)
      print("""
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
  
  private func hasError(statusCode: Int) -> Bool {
    return (statusCode < 200 || statusCode > 299)
  }
  
  private func logRequestInfo(with path: String) {
    NetworkingLogger.write(log: "API full api: \(path)", logLevel: .warning)
    NetworkingLogger.write(log: "[\(type(of: self.input))][Type]: HTTP.\(self.input.requestType)", logLevel: .verbose)
    NetworkingLogger.write(log: "[\(type(of: self.input))][Param]: \(self.input.makeRequestableBody())",
                    logLevel: .verbose)
    NetworkingLogger.write(log: "[\(type(of: self.input))][Encode]: \(input.getBodyEncode())",
                    logLevel: .verbose)
  }
}
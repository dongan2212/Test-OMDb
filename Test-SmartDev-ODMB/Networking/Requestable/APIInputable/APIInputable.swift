//
//  APIInputable.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

public enum APIRequestType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

public enum BodyEncode {
    case formdata
    case json
}

public protocol APIInputable {
    var requestType: APIRequestType { get }
    var pathToApi: String { get }
    
    func makeFullPathToApi(with config: APIConfigable) -> String
    
    func makeRequestableBody() -> [String: Any]
    
    func makeRequestableHeader() -> [String: String]
    
    func makeUrlParamReplace() -> [String: String]
    
    func getBodyEncode() -> BodyEncode
    
    func shouldBroadcastStatusCode() -> Bool
}

extension APIInputable {
    public func getBodyEncode() -> BodyEncode {
        return .json
    }
    
    public func shouldBroadcastStatusCode() -> Bool {
        return true
    }
    
    public func makeFullPathToApi(with config: APIConfigable) -> String {
        var result = config.host + self.pathToApi
        self.makeUrlParamReplace().forEach({ result = result.replacingOccurrences(of: $0.key,
                                                                                  with: $0.value) })
        return result
    }
    
    public func makeUrlParamReplace() -> [String: String] {
        return [:]
    }
}

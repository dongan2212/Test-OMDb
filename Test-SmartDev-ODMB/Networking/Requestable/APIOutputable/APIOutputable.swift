//
//  APIOutputable.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

public protocol APIOutputable: AnyObject {
  associatedtype ResultType
  associatedtype ErrorType
  var responseParser: Parseable { get set }
  var errorParser: Parseable { get set }
  var result: ResultType? { get set }
  var error: ErrorType? { get set }
  func convertData(from data: Data?)
  func convertError(from data: Data?, systemError: Error?)
  func hasError() -> Bool
}

struct AssociatedKeys {
  static var errorServer: UInt8 = 0
}

public extension APIOutputable {
  private(set) var errorServerInfomation: Error? {
    get {
      guard let value = objc_getAssociatedObject(self, &AssociatedKeys.errorServer) as? Error else {
        return nil
      }
      return value
    }
    
    set {
      objc_setAssociatedObject(self,
                               &AssociatedKeys.errorServer, newValue,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  func convertData(from data: Data?) {
    guard let concreteData = data else {
      return
    }
    self.result = responseParser.parse(concreteData)
  }
  
  func convertError(from data: Data?, systemError: Error?) {
    self.errorServerInfomation = systemError
    guard let concreteData = data else {
      return
    }
    self.error = errorParser.parse(concreteData)
  }
  
  func hasError() -> Bool {
    return (self.errorServerInfomation != nil) || (self.error != nil)
  }
}

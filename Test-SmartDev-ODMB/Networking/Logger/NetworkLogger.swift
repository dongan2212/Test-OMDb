//
//  NetworkLogger.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

enum LogLevel: Int {
  case verbose
  case warning
  case error
}

class NetworkingLogger {
  static var logWriter: Loggable = ConsoleLogger()
  static let logPrefix = "[Networking]"
  static let logWriterLevel: LogLevel = .verbose
  static func write(log: String, logLevel: LogLevel = .verbose) {
    if logWriterLevel.rawValue <= logLevel.rawValue {
      logWriter.write(log: log)
    }
  }
}

protocol Loggable {
  func write(log: String)
}

/// Please use this class in case you need to write debug log into console
class ConsoleLogger: Loggable {
  /// Write to the console
  /// - Parameter log: the string that will be write to screen
  func write(log: String) {
    print("\(NetworkingLogger.logPrefix)\(log)")
  }
}

/// Please use this logger incase you need disable all the log from our system
class NullLogger: Loggable {
  /// Write nothing
  /// - Parameter log: this param is not used.
  func write(log: String) {
  }
}

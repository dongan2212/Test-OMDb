//
//  DebugLogger.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

/*
 Logger.verbose("not so important")  // prio 1, VERBOSE in silver
 Logger.debug("something to debug")  // prio 2, DEBUG in blue
 Logger.info("a nice information")   // prio 3, INFO in green
 Logger.warning("oh no, that won’t be good")  // prio 4, WARNING in yellow
 Logger.error("ouch, an error did occur!")  // prio 5, ERROR in red
*/

class Logger {
    class func verbose(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG || UAT
            let fileName = (file as NSString).lastPathComponent
            let className = (fileName as NSString).deletingPathExtension

            let cutFuntionName = function.firstIndex(of: "(")
            if let cutFuntionName = cutFuntionName {
                let functionName = function[..<cutFuntionName]
                print(" 💜 VERBOSE \(className):\(line) 🔹 \(functionName) 🔸 \(message)")
            } else {
                print(" 💜 VERBOSE \(className):\(line) 🔹 nil 🔸 \(message)")
            }

        #endif
    }

    class func debug(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG || UAT
            let fileName = (file as NSString).lastPathComponent
            let className = (fileName as NSString).deletingPathExtension

            let cutFuntionName = function.firstIndex(of: "(")
            if let cutFuntionName = cutFuntionName {
                let functionName = function[..<cutFuntionName]
                print(" 💚 DEBUG \(className):\(line) 🔹 \(functionName) 🔸 \(message)")
            } else {
                print(" 💚 DEBUG \(className):\(line) 🔹 nil 🔸 \(message)")
            }

        #endif
    }

    class func info(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG || UAT
            let fileName = (file as NSString).lastPathComponent
            let className = (fileName as NSString).deletingPathExtension

            let cutFuntionName = function.firstIndex(of: "(")
            if let cutFuntionName = cutFuntionName {
                let functionName = function[..<cutFuntionName]
                print(" 💙 INFO \(className):\(line) 🔹 \(functionName) 🔸 \(message)")
            } else {
                print(" 💙 INFO \(className):\(line) 🔹 nil 🔸 \(message)")
            }

        #endif
    }

    class func warning(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG || UAT
            let fileName = (file as NSString).lastPathComponent
            let className = (fileName as NSString).deletingPathExtension

            let cutFuntionName = function.firstIndex(of: "(")
            if let cutFuntionName = cutFuntionName {
                let functionName = function[..<cutFuntionName]
                print(" 💛 WARNING \(className):\(line) 🔹 \(functionName) 🔸 \(message)")
            } else {
                print(" 💛 WARNING \(className):\(line) 🔹 nil 🔸 \(message)")
            }

        #endif
    }

    class func error(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG || UAT
            let fileName = (file as NSString).lastPathComponent
            let className = (fileName as NSString).deletingPathExtension

            let cutFuntionName = function.firstIndex(of: "(")
            if let cutFuntionName = cutFuntionName {
                let functionName = function[..<cutFuntionName]
                print(" ❤️ ERROR \(className):\(line) 🔹 \(functionName) 🔸 \(message)")
            } else {
                print(" ❤️ ERROR \(className):\(line) 🔹 nil 🔸 \(message)")
            }

        #endif
    }

    class func DLog(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG || UAT
            let fileName = (file as NSString).lastPathComponent
            let className = (fileName as NSString).deletingPathExtension

            let cutFuntionName = function.firstIndex(of: "(")
            if let cutFuntionName = cutFuntionName {
                let functionName = function[..<cutFuntionName]
                NSLog("DEBUGG \(className):\(line) 🔹 \(functionName) 🔸 \(message)")
            } else {
                NSLog("DEBUGG \(className):\(line) 🔹 nil 🔸 \(message)")
            }
        #endif
    }
}

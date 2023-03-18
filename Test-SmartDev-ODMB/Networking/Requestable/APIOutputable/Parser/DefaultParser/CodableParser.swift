
//
//  CodableParser.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

public protocol Parseable {
    func parse<T>(_ data: Data) -> T?
}

public class CodeableParser<ParsingType: Decodable>: Parseable {
    public init() { }
    public func parse<T>(_ data: Data) -> T? {
        debugPrint("==>T:\(T.self)")
        do {
            return try JSONDecoder().decode(ParsingType.self, from: data) as? T
        } catch let DecodingError.dataCorrupted(context) {
            Logger.error("Coding Path: \(context.codingPath)")

            print("Coding Path: \(context.codingPath)")
        } catch let DecodingError.keyNotFound(key, context) {
            Logger.error("Key '\(key)' not found: \(context.debugDescription)")
            Logger.error("Coding Path: \(context.codingPath)")

            print("Key '\(key)' not found: \(context.debugDescription)")
            print("Coding Path: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            Logger.error("Value '\(value)' not found: \(context.debugDescription)")
            Logger.error("Coding Path: \(context.codingPath)")

            print("Value '\(value)' not found: \(context.debugDescription)")
            print("Coding Path: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context) {
            Logger.error("Type '\(type)' mismatch: \(context.debugDescription)")
            Logger.error("Coding Path: \(context.codingPath)")

            print("Type '\(type)' mismatch: \(context.debugDescription)")
            print("Coding Path: \(context.codingPath)")
        } catch {
            Logger.error("Decoding Error: \(error.localizedDescription)")

            print("Decoding Error: \(error.localizedDescription)")
        }
        return nil
    }
}

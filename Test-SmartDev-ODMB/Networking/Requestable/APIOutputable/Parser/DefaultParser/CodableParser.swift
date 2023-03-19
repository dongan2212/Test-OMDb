
//
//  CodableParser.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation

protocol Parseable {
    func parse<T>(_ data: Data) -> T?
}

class CodeableParser<ParsingType: Decodable>: Parseable {
    init() { }

    func parse<T>(_ data: Data) -> T? {
        do {
            return try JSONDecoder().decode(ParsingType.self, from: data) as? T
        } catch let DecodingError.dataCorrupted(context) {
            Logger.error("Coding Path: \(context.codingPath)")
        } catch let DecodingError.keyNotFound(key, context) {
            Logger.error("Key '\(key)' not found: \(context.debugDescription)")
            Logger.error("Coding Path: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            Logger.error("Value '\(value)' not found: \(context.debugDescription)")
            Logger.error("Coding Path: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context) {
            Logger.error("Type '\(type)' mismatch: \(context.debugDescription)")
            Logger.error("Coding Path: \(context.codingPath)")
        } catch {
            Logger.error("Decoding Error: \(error.localizedDescription)")
        }
        return nil
    }
}

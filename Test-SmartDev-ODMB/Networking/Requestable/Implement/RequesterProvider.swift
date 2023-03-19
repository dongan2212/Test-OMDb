//
//  RequesterProvider.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Foundation
import Alamofire

protocol RequesterProviable {
    func makeRequest(path: String,
                     requestType: APIRequestType,
                     headers: [String: String],
                     params: [String: Any],
                     complete: @escaping (APIResponse) -> Void)
    func makeFormDataRequest(path: String,
                             requestType: APIRequestType,
                             headers: [String: String],
                             params: [String: Any],
                             complete: @escaping (APIResponse) -> Void)
}

class AlamofireRequesterProvider: RequesterProviable {
    func makeRequest(path: String,
                     requestType: APIRequestType,
                     headers: [String: String],
                     params: [String: Any],
                     complete: @escaping (APIResponse) -> Void) {
        AF.request(path,
                   method: HTTPMethod(rawValue: requestType.rawValue),
                   parameters: params,
                   encoding: (requestType == .get) ? URLEncoding.default : JSONEncoding.default,
                   headers: HTTPHeaders(headers)
        ).responseJSON { (response) in
            complete((response.data, response.error, response.response?.statusCode))
        }
    }

    func makeFormDataRequest(path: String,
                             requestType: APIRequestType,
                             headers: [String: String],
                             params: [String: Any],
                             complete: @escaping (APIResponse) -> Void) {
        Logger.info("requestType:\(requestType)")
        AF.upload(
            multipartFormData: { formData in
                for param in params {
                    if let string = param.value as? String,
                        let stringData = string.data(using: .utf8) {
                        formData.append(stringData, withName: param.key)
                    }
                    if let fileData = param.value as? Data {
                        if path.contains("video") {
                            formData.append(fileData, withName: param.key, fileName: "upload_video.mov", mimeType: "video/mov")
                        } else {
                            formData.append(fileData, withName: param.key, fileName: "upload_image.png", mimeType: "image/png")
                        }
                    }
                    if let array = param.value as? [String] {
                        let arrayData = array.map({ $0.data(using: .utf8) }).compactMap({ $0 })
                        arrayData.forEach { value in
                            formData.append(value, withName: param.key)
                        }
                    }
                }
            },
            to: path,
            method: HTTPMethod(rawValue: requestType.rawValue),
            headers: HTTPHeaders(headers)
        ).responseJSON { (response) in
            Logger.info("response:\(response)")
            if let dataConcrete = response.data {
                Logger.error("[Error]: \(String(decoding: dataConcrete, as: UTF8.self))")
            }
            Logger.info("statusCode:\(response.response?.statusCode)")
            complete((response.data, response.error, response.response?.statusCode ?? 200))
        }
    }
}

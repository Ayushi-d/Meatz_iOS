
//
//  ResultError.swift
//  kiddo
//
//  Created by Khaled kamal on 12/29/19.
//  Copyright © 2019 spark-cloud. All rights reserved.
//

import UIKit

// public protocol LocalizedError {
//    var error : String{get}
// }
// extension LocalizedError {
//    var error : String {return ""}
// }

public enum ResponseStatusCode {
    init(_ statusCode: Int, error: String?, response: Data?) {
        switch statusCode {
        case 200 ... 299:

            self = ResponseStatusCode.success

        case 400 ... 499:

            guard let jsonObject = try? JSONSerialization.jsonObject(with: response ?? Data(), options: []) as? [String: Any] else { self = ResponseStatusCode.serverError(ResultError(statusCode, error: error))
                return
            }
            if let message = jsonObject["message"] as? String {
                self = ResponseStatusCode.serverError(ResultError.messageError(message))
            } else {
                self = ResponseStatusCode.serverError(ResultError(statusCode, error: error))
            }

        default: self = ResponseStatusCode.serverError(ResultError(statusCode, error: error))
        }
    }

    case success
    case serverError(ResultError)
}

public enum ResultError : Error {
    init(_ statusCode: Int, error: String?) {
        switch statusCode {
        case NSURLErrorCannotDecodeRawData, NSURLErrorCannotDecodeContentData, NSURLErrorCannotParseResponse: self = .cannotDecodeData
        case NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet: self = .noInternt

        default: self = .serverError(ServerError(statusCode, error: error))
        }
    }

    case cannotDecodeData

    case noInternt
    case messageError(String?)
    case serverError(ServerError)

    public var describtionError: String {
        switch self {
        case let .serverError(error):
            return error.error

        case .noInternt:
            return NSLocalizedString("No Internet connection.Make sure that Wi-Fi or mobile data is turned on that try again", comment: "")
        case let .messageError(error):
            return error ?? ""
        default:
            return ""
        }
    }
}

public enum ServerError {
    init(_ errorCode: Int, error: String?) {
        switch errorCode {
        case NSURLErrorBadURL, NSURLErrorUnsupportedURL, NSURLErrorCannotFindHost: self = .badUrl
        case 401: self = .tokenExpire
        case 403: self = .forbiden
        case 412: self = .validateInputs
        case 500: self = .internalServerError

        default: self = .error(error)
        }
    }

    case error(String?) // Error.Description
    case badUrl // 400
    case tokenExpire // 401
    case validateInputs // 412
    case forbiden // 403
    case internalServerError // 500
    case badServerResponse

    public var error: String {
        switch self {
        case let .error(errorDescription):
            return errorDescription ?? ""

        case .badUrl:
            return "Bad url , you cannot access method"

        default:
            return "Server Error"
        }
    }
}

//
// public enum ErrorType {
//
//    init(_ errorCode : String) {
//        switch errorCode {
//        case "400" : self = .badUrl
//        case "401" : self = .tokenExpire
//        case "403" : self = .forbiden
//        case "412" : self = .validateInputs
//        case "500" : self = .internalServerError
//        }
//    }
//
//
//    case cannotDecode //Handle ComminDate
//
//
//    case noInternet //---
//    case error(String) // Error.Description
//    case tokenExpire // 401
//    case validateInputs //412
//    case badUrl // 400
//    case forbiden //403
//    case internalServerError //500
//
//    var describtion : String{
//        switch self {
//        case .cannotDecode: return  NSLocalizedString("cannotDecode", comment: "")
//        case .noInternet:   return  NSLocalizedString("noInternet", comment: "")
//        case .error(let error): return  error
//        case .tokenExpire:      return  NSLocalizedString("tokenExpire", comment: "")
//        case .validateInputs:   return  NSLocalizedString("validateInputs", comment: "")
//        case .badUrl:   return  NSLocalizedString("badUrl", comment: "")
//        case .forbiden: return  NSLocalizedString("forbiden", comment: "")
//        case .internalServerError: return  NSLocalizedString("internalServerError", comment: "")
//        }
//    }
// }

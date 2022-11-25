//
//  BaseRequstBuilder.swift
//  Mandob
//
//  Created by khaledkamal on 7/29/18.
//  Copyright © 2018 khaledkamal. All rights reserved.
//

import Alamofire
import Foundation

public protocol BaseRequstBuilder: URLRequestConvertible, BaseRequestHandler, BaseMultiRequestHandler {
    // Path
    var mainPath: String { get }
    var urlPath: String { get }

    // Paramter
    var paramter: [String: Any]? { get }

    // Headers
    var headers: HTTPHeaders { get }

    // Http Method
    var hettpMethod: HTTPMethod { get }

    //
    var urlRequest: URLRequest { get }
    var encoding: ParameterEncoding { get }
    var httpBody : Data?{get}
}

extension BaseRequstBuilder {
    // ---------Path
    var mainPath: String {
        //return "http://88.208.227.238/api/"
        //return "http://meatz.testingjunction.tech/api/"
        return "http://meatz-app.com/api/"
    }

    // Paramter
    var paramter: [String: Any]? {
        return nil
    }

    var multipartParmter: [String: Any] {
        return paramter!
    }

    // Headers
    var headers: HTTPHeaders {
        return SHeaders.shared.headers
    }

    // Http Method
    var hettpMethod: HTTPMethod {
        return .get
    }

    var httpBody : Data?{
        return nil
    }
    //=================================================
    var encoding: ParameterEncoding {
        return URLEncoding.default
        //
        //        switch hettpMethod {
        //        case .get:
        //            return URLEncoding.default
        //
        //        default:
        //            return JSONEncoding.default
        //        }
    }

//    var urlRequest: URLRequest {
//        var request = URLRequest(url: URL(string: mainPath + urlPath)!)/// لو الurlفيه مسافات هيضرب هنا 
//        request.httpMethod = hettpMethod.rawValue
//        request.allHTTPHeaderFields = headers
//        print("Headers:", headers)
//        return request
//    }

    var urlRequest: URLRequest {
        let _urlPath = (mainPath + urlPath).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""

        guard let _url = URL(string: _urlPath) else {
            fatalError("Invalid url ............")
        }

        var request = URLRequest(url: _url)

        request.httpMethod = hettpMethod.rawValue

        request.headers = headers
        request.httpBody = httpBody
        print(headers)
        return request
    }

    // MARK: - URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        print("Url :\(String(describing: urlRequest.url)) parm:\(String(describing: paramter)) ")
        return try encoding.encode(urlRequest, with: paramter)
    }

    //=================================================
}

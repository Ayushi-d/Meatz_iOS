//
//  BaseRequestHandler.swift
//  Mandob
//
//  Created by khaledkamal on 7/29/18.
//  Copyright © 2018 khaledkamal. All rights reserved.
//

import Alamofire
import Foundation

public typealias ResponseResult<T> = (ResultStatuts<T>) -> Void

public protocol BaseRequestHandler {
    func sendRequst<T: Codable>(data: T.Type, compltion: @escaping ResponseResult<T>)
}

extension BaseRequestHandler where Self: URLRequestConvertible {
    func sendRequst<T: Codable>(data _: T.Type, compltion: @escaping ResponseResult<T>) {
        AF.request(self).validate(statusCode: 200 ..< 600).responseJSON { response_ in
            print(response_.result)

            //=======================================================
            let parse = RequstParsing()
            parse.handleResponse(response_, completion: compltion)
            //========================================================
        }
    }
}

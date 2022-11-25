//
//  RequstParsing.swift
//  kiddo
//
//  Created by Mac on 12/26/19.
//  Copyright © 2019 spark-cloud. All rights reserved.
//

import UIKit
import Alamofire

public protocol BaseResponseHandler {
    func handleResponse<T>(_ response: AFDataResponse<Any>, completion: @escaping ResponseResult<T>) where T: Codable
}

public class RequstParsing: NSObject {}

extension RequstParsing: BaseResponseHandler {
    public func handleResponse<T>(_ response: AFDataResponse<Any>, completion: @escaping ResponseResult<T>) where T: Codable {
        // If error Found------------
        guard let urlResponse = response.response else {
            if let error = response.error as NSError?, error.code == NSURLErrorNotConnectedToInternet {
                completion(ResultStatuts<T>.failure(ResultError.noInternt))
            } else {
                completion(ResultStatuts<T>.failure(ResultError.serverError(.error(response.error?.localizedDescription))))
            }
            return
        }

        let status = ResponseStatusCode(urlResponse.statusCode, error: response.error?.localizedDescription, response: response.data)
        print("-------- Response ---------")
        print(String(data: response.data ?? Data(), encoding: .utf8))
        switch status {
        case .success:
            
            if let json = response.data {
                do {
                    let decoder = JSONDecoder()
                    let modules = try decoder.decode(T.self, from: json)
                    completion(ResultStatuts<T>.success(modules))
                } catch {
                    print("Cannot decode")
                    completion(ResultStatuts<T>.failure(ResultError.serverError(.error(error.localizedDescription))))
                    print(error)
                }
            } else {
                print("Cannot decode")
                completion(ResultStatuts<T>.failure(ResultError.cannotDecodeData))
            }

        case let .serverError(serverError): completion(ResultStatuts<T>.failure(serverError))
        }
    }
}

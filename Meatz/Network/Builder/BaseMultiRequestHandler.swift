//
//  BaseMultiRequestHandler.swift
//  Servent
//
//  Created by Khaled kamal on 2/11/20.
//  Copyright © 2020 Khaled kamal. All rights reserved.
//

import Alamofire
import Foundation

// MARK: - MultiPart

public protocol BaseMultiRequestHandler {
    // MARK: - Paramter

    var multipartParmter: [String: Any] { get }

    // MARK: - Method

    func uploadMuliPart<T: Codable>(data: T.Type, compltion: @escaping ResponseResult<T>)
}

/////
extension URLRequest: URLConvertible {
    public func asURL() throws -> URL {
        guard let url = self.url else { throw AFError.invalidURL(url: self) }
        return url
    }
}

extension BaseMultiRequestHandler where Self: URLRequestConvertible {
    func uploadMuliPart<T: Codable>(data _: T.Type, compltion: @escaping ResponseResult<T>) {
        guard let reqHeaders = self.urlRequest?.headers else {
            return
        }

        let upload_ = AF.upload(multipartFormData: asMultiPartData(), to: urlRequest!, headers: reqHeaders)

        upload_.validate().uploadProgress(closure: { _ in

               }).responseJSON { response_ in

            print(response_.result)

            //=======================================================

            let parse = RequstParsing()

            parse.handleResponse(response_, completion: compltion)

            //========================================================
        }
    }

    fileprivate func asMultiPartData() -> MultipartFormData {
        let multiPartForm = MultipartFormData()
        for (key, value) in multipartParmter {
            if let image_ = value as? UIImage, let img_data = image_.jpegData(compressionQuality: 0.2) {
                multiPartForm.append(img_data, withName: key, fileName: "\(key).png", mimeType: "image/png")
            } else {
                multiPartForm.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }
        return multiPartForm
    }
}

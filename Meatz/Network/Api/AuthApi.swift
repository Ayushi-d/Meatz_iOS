//
//  AuthApi.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/7/21.
//

import Alamofire
import Foundation

enum AuthApi: BaseRequstBuilder {
    case login(Parameters)
    case signUp(Parameters)
    case forgotPass(Parameters)
    case socialLogin(Parameters)
    
    var urlPath: String {
        switch self {
        case .login:
            return "login"
        case .signUp:
            return "signup"
        case .forgotPass:
            return "forget"
        case .socialLogin:
            return "social_login"
        }
    }
    
    var hettpMethod: HTTPMethod {
        return .post
    }
    
    var paramter: [String: Any]? {
        switch self {
        case .login(let params),
             .signUp(let params),
             .forgotPass(let params),
             .socialLogin(let params):
            return params.body
        }
    }
    
    var headers: HTTPHeaders {
        return SHeaders.shared.headers
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

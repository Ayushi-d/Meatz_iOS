//
//  SocialLoginHelper.swift
//  Le Service
//
//  Created by Nabil Elsherbene on 10/12/20.
//  Copyright © 2020 spark cloud. All rights reserved.
//

import Foundation

public enum SocialLoginType: String {
    case facebook
    case google
    case apple
}

public struct SocialBodyParameters: Parameters {
    var email: String = ""
    var name: String = ""
    var token: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var socialType: SocialLoginType = .facebook

    var body: [String: Any] {
        return ["email": email,
                "name": name,
                "first_name": firstName,
                "last_name": lastName,
                "mobile": phone,
                "social_type": socialType.rawValue,
                "social_id": token]
    }
}

//
//  KHeaders.swift
//  kiddo
//
//  Created by Khaled kamal on 12/29/19.
//  Copyright © 2019 spark-cloud. All rights reserved.
//

import UIKit
import Alamofire
public struct SHeaders {
    // Only one instance
    static var shared = SHeaders()

    // MARK: - Properities

    private var firbaseToken: String?
    private var authToken: String?
    private var language: String

    // MARK: - Init

    private init() {
        //let token: String? = ""
        firbaseToken = UserDefaults.standard.string(forKey: "FbToken")
        authToken = ""
        language = MOLHLanguage.currentAppleLanguage().rawValue
    }

    // Headers
    public var headers: HTTPHeaders {
        return ["FbToken": firbaseToken ?? "",
                "lang": language,
                "Authorization" : "Bearer" + " " + (CachingManager.shared.getUser()?.accessToken ??  ""),
                "Accept":"application/json"]//firbaseToken ?? ""]
    }
}

public extension SHeaders {
    mutating func updateAuthToken(_ value: String?) {
        authToken = value
    }

    mutating func updateFirbaseToken(_ value: String?) {
        firbaseToken = value
    }

    mutating func updateLanguage(_ value : String)
    {
        language = value
    }
}

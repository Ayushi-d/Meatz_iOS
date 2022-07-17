//
//  SocialLoginHelper.swift
//  Le Service
//
//  Created by Nabil Elsherbene on 10/12/20.
//  Copyright © 2020 spark cloud. All rights reserved.
//

//import FBSDKLoginKit
import Foundation

enum NetworkError: Error, LocalizedError {
    case cancelled

    var errorDescription: String? {
        switch self {
        case .cancelled:
            return "cancelled"
        default:
            return ""
        }
    }
}

enum SocialResult<Value> {
    case success(Value)
    case failure(Error)
}

protocol FacebookLoginHelperProtocol {
    func login(withPermissions permissions: [Permissions], fields: [Fields])
}

protocol FacebookLoginHelperDelegate: class {
    func didAuthenticate(info: SocialBodyParameters)
    func didFail(with error: Error)
}

enum Permissions: String {
    case publicProfile = "public_profile"
    case email
}

enum Fields {
    case id
    case firstName
    case lastName
    case picture(width: Int)
    case phone
    case email
    case name

    var value: String {
        switch self {
        case .id:
            return "id"
        case .name:
            return "name"
        case .firstName:
            return "first_name"
        case .lastName:
            return "last_name"
        case .phone:
            return "phone"
        case .email:
            return "email"
        case let .picture(width):
            return "picture.width(\(width))"
        }
    }
}

//class FacebookLoginHelper: FacebookLoginHelperProtocol {
//    private let facebookLoginManager = LoginManager()
//    weak var delegate: FacebookLoginHelperDelegate?
//    private let owner: UIViewController
//    private var data = SocialBodyParameters()
//
//    init(owner: UIViewController) {
//        self.owner = owner
//    }
//
//    private func fetchFacebookProfile(fields: String, completionHandler: @escaping (SocialResult<SocialBodyParameters>) -> Void) {
//        GraphRequest(graphPath: "me", parameters: ["fields": fields]).start { [weak self] _, result, error in
//
//            guard let self = self else { return }
//            if let error = error {
//                completionHandler(.failure(error))
//            } else {
//                guard let userInfo = result as? [String: AnyObject] else { return }
//
//                self.data.token = AccessToken.current?.tokenString ?? ""
//                self.data.email = userInfo["email"] as? String ?? ""
//                self.data.name = userInfo["name"] as? String ?? ""
//                self.data.firstName = userInfo["first_name"] as? String ?? ""
//                self.data.lastName = userInfo["last_name"] as? String ?? ""
//                self.data.phone = userInfo["phone"] as? String ?? ""
//                self.data.socialType = .facebook
//                completionHandler(.success(self.data))
//            }
//        }
//    }
//
//    func login(withPermissions permissions: [Permissions], fields: [Fields]) {
//        facebookLoginManager.logOut()
//        let permissionsStrings = permissions.map { $0.rawValue }
//        let requestedFields = fields.map { $0.value }.joined(separator: ",")
//        facebookLoginManager.logIn(permissions: permissionsStrings, from: owner) { [weak self] result, error in
//            guard let self = self else { return }
//            if let error = error {
//                self.delegate?.didFail(with: error)
//            } else {
//                guard let result = result else { return }
//                if !result.isCancelled {
//                    self.fetchFacebookProfile(fields: requestedFields) { [weak self] result in
//                        guard let self = self else { return }
//                        switch result {
//                        case let .success(info):
//                            self.delegate?.didAuthenticate(info: info)
//                        case let .failure(error):
//                            self.delegate?.didFail(with: error)
//                        }
//                    }
//                } else {
//                    self.delegate?.didFail(with: NetworkError.cancelled)
//                }
//            }
//        }
//    }
//}

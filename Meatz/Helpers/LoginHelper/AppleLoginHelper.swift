//
//  AppleLoginHelper.swift
//  Le Service
//
//  Created by Nabil Elsherbene on 10/12/20.
//  Copyright © 2020 spark cloud. All rights reserved.


 import AuthenticationServices
 import Foundation

 enum AppleUSerKeys: String {
    case AppleUSerKey = "AppleUserData"
    case identifier = "AppleUserIdentifier"
    case email = "AppleUserEmail"
    case firstName = "AppleUserGivenName"
    case lastName = "AppleUserLastName"
 }

 protocol AppleLoginHelperProtocol {
    func login()
 }

 protocol AppleLoginHelperDelegate: class {
    func didFetchAppleAccountData(with info: Parameters)
    func didFail(with error: Error)
 }

 class AppleLoginHelper: NSObject, ASAuthorizationControllerDelegate {
    private let owner: UIViewController
    private let appleIDProvider = ASAuthorizationAppleIDProvider()
    weak var delegate: AppleLoginHelperDelegate?
    private var appleUserData = AppleUserData()
    var shareRefrence: SharedRefrencProtocol

    init(owner: UIViewController) {
        self.owner = owner
        self.shareRefrence = SharedRefrences.shared
        super.init()
    }
 }

 extension AppleLoginHelper: AppleLoginHelperProtocol {
    func login() {
        /// Retrive user of Apple in keyShine
        /// Retrive id of apple user  from keyshine

        if let userAppleData: AppleUserData = shareRefrence.getElement(forKey: AppleUSerKeys.AppleUSerKey.rawValue) {
            appleIDProvider.getCredentialState(forUserID: userAppleData.userId) { state, _ in
                switch state {
                case .authorized:
                    /// retrive data from keushine
                    self.delegate?.didFetchAppleAccountData(with: userAppleData)
                case .revoked:
                    self.siginWithApple()
                case .notFound:
                    self.siginWithApple()

                default:
                    return
                }
            }
        } else {
            siginWithApple()
        }
    }

    private func siginWithApple() {
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()

 }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")

            /// Must save data in key shine

            appleUserData.userId = userIdentifier
            appleUserData.email = email ?? ""
            appleUserData.firstName = fullName?.givenName ?? ""
            appleUserData.lastName = fullName?.familyName ?? ""
            appleUserData.name = fullName?.description ?? ""
            shareRefrence.setElement(appleUserData, forKey: AppleUSerKeys.AppleUSerKey.rawValue)

            /// perofrmDelegate
            delegate?.didFetchAppleAccountData(with: appleUserData)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.didFail(with: error)
    }
 }


// MARK: - Apple User fields

enum AppleUserFields {
    case userId(String?)
    case email(String?)
    case firstName(String?)
    case lastName(String?)
    case name(String?)
}

// MARK: - Apple User Data

struct AppleUserData: Codable, Parameters {
    var userId = ""
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var name: String = ""

    init() {}

    var body: [String: Any] {
        return ["email": email,
                "name": name,
                "first_name": firstName,
                "last_name": lastName,
                "mobile": "",
                "social_type": SocialLoginType.apple.rawValue,
                "social_id": userId]
    }
}

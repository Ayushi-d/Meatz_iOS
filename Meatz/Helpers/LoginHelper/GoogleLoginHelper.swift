//
//  SocialLoginHelper.swift
//  Le Service
//
//  Created by Nabil Elsherbene on 10/12/20.
//  Copyright © 2020 spark cloud. All rights reserved.
//

import Foundation
import GoogleSignIn

protocol GoogleLoginHelperProtocol {
    func login()
}

protocol GoogleLoginHelperDelegate: class {
    func didAuthenticate(with info: SocialBodyParameters)
    func didFail(with error: Error)
}

//class GoogleLoginHelper: NSObject, GIDSignInDelegate, GoogleLoginHelperProtocol {
//    private let owner: UIViewController
//    weak var delegate: GoogleLoginHelperDelegate?
//    private var data = SocialBodyParameters()
//
//    init(owner: UIViewController) {
//        self.owner = owner
//        super.init()
////        GIDSignIn.sharedInstance()?.uiDelegate = self
//            ..//  GIDSignIn.sharedInstance()?.presentingViewController = owner
//       // GIDSignIn.sharedInstance()?.delegate = self
//    }

    func login() {
       // GIDSignIn.sharedInstance()?.signOut()
       // GIDSignIn.sharedInstance()?.signIn()
    }

//    func sign(_: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            if error.localizedDescription.contains("canceled") {
//                delegate?.didFail(with: NetworkError.cancelled)
//            } else {
//                delegate?.didFail(with: error)
//            }
//        } else {
////            data.token = user.authentication.accessToken
//            //user.authentication.idToken
//            data.token = user.userID// Safe to send to the server
//            data.name = user.profile.name
//            data.firstName = user.profile.givenName
//            data.lastName = user.profile.familyName
//            data.email = user.profile.email
//            data.socialType = .google
//
//            delegate?.didAuthenticate(with: data)
//        }
//    }

//    func sign(_: GIDSignIn!, present viewController: UIViewController!) {
//        owner.present(viewController, animated: true, completion: nil)
//    }
//
//    func sign(_: GIDSignIn!, dismiss _: UIViewController!) {
//        owner.dismiss(animated: true, completion: nil)
//    }
//}

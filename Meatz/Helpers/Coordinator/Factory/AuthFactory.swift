//
//  AuthFactory.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/7/21.
//

import Foundation

protocol AuthFactoryProtocol : class {
    func login()->LoginView
    func register() -> RegisterView
    func forgetPass() -> ForgotPassView
    func terms() -> TermsView
}

final class AuthFactory : AuthFactoryProtocol{
    
    private weak var coordinator: AuthCoordinator?
    init(_ coordinator: AuthCoordinator?) {
        self.coordinator = coordinator
    }

    func login() -> LoginView {
        let vc = R.storyboard.auth.loginView()!
        //let faceBookLoginHelper = FacebookLoginHelper(owner: vc)
       // let googleLoginHelper = GoogleLoginHelper(owner: vc)
       // let appleLoginHelper = AppleLoginHelper(owner: vc)
        vc.viewModel = LoginViewModel(LoginRepo(), coordinator)
//        vc.viewModel = LoginViewModel(LoginRepo(), coordinator, faceBookLoginHelper: faceBookLoginHelper, googleLoginHelper: googleLoginHelper, appleLoginHelper: appleLoginHelper)
//        faceBookLoginHelper.delegate = (vc.viewModel as! FacebookLoginHelperDelegate)
//        googleLoginHelper.delegate = (vc.viewModel as! GoogleLoginHelperDelegate)
//        appleLoginHelper.delegate = (vc.viewModel as! AppleLoginHelperDelegate)
        return vc 
    }
    
    
    func register() -> RegisterView {
        let vc = R.storyboard.auth.registerView()!
        vc.viewModel = RegisterViewModel(RegisterRepo(), coordinator)
        return vc 
    }
    
    func forgetPass() -> ForgotPassView {
        let vc = R.storyboard.auth.forgotPassView()!
        vc.viewModel = ForgotPassViewModel(ForgotPassRepo(), coordinator)
        return vc 
    }
    
    func terms() -> TermsView {
        let vc = R.storyboard.main.termsView()!
        vc.viewModel = TermsViewModel(TermsRepo(), coordinator)
        return vc
    }
}


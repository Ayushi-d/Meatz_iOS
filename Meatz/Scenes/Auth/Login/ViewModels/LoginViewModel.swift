//
//  LoginViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/7/21.
//

import Foundation
  //private var coordinator: Coordinator?

final class LoginViewModel {
    private var repo: LoginRepoProtocol?
    private var coordinator: Coordinator?
   // private let faceBookLoginHelper: FacebookLoginHelperProtocol
    //private let googleLoginHelper: GoogleLoginHelper
   // private let appleLoginHelper: AppleLoginHelper
    var onRequestCompletion: ((_ message: String?) -> Void)?
    var state: State = .notStarted
    var requestError: Observable<ResultError>? = Observable(nil)
    var parameters = LoginParams()
    init(_ repo: LoginRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        //self.faceBookLoginHelper = faceBookLoginHelper
       // self.googleLoginHelper = googleLoginHelper
       // self.appleLoginHelper = appleLoginHelper
        self.coordinator = coordinator
    }
}

extension LoginViewModel: LoginVMProtocol {
    func updateParameters(_ field: LoginField) {
        switch field {
        case .email(let value):
            parameters.email = value
        case .password(let value):
            parameters.password = value
        }
    }

    func login() {
        guard isValid() else { return }
        repo?.loginWith(parameters) { [weak self] result in
            guard let self = self else { return }
            self.handelResponse(result)
        }
    }

    private func handelResponse(_ result: Result<AuthModel, ResultError>) {
        switch result {
        case .success(let model):
            state = .success
            guard CachingManager.shared.cache(model.user) else {
                requestError?.value = .messageError(R.string.localizable.somethingWenWrong())
                return
            }
            guard let completion = onRequestCompletion else { return }
            completion(model.message)
        case .failure(let error):
            state = .finishWithError(error)
            requestError?.value = error
        }
    }

    private func isValid() -> Bool {
        guard !parameters.email.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourEmail())
            return false
        }
        guard parameters.email.isValidEmail() else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterAValidEmail())
            return false
        }
        guard !parameters.password.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourPassword())
            return false
        }

        guard parameters.password.count >= 8 else {
            requestError?.value = .messageError(R.string.localizable.passLengthValidation())
            return false
        }

        return true
    }

    func continueAsGuest() {
        navigateToHome()
    }

    func register() {
        coordinator?.navigateTo(AuthDestination.register)
    }

    func forgetPass() {
        coordinator?.navigateTo(AuthDestination.forgetPass)
    }

    func navigateToHome() {
        coordinator?.pop(false)
        coordinator?.parent?.start()
    }

    public func faceboockLoginTapped() {
      //  faceBookLoginHelper.login(withPermissions: [.publicProfile, .email], fields: [.id, .email, .firstName, .lastName, .name])
    }

    public func gmailButtonTapped() {
       // googleLoginHelper.login()
    }

    public func appleButtonTapped() {
       // appleLoginHelper.login()
    }

    private func fireSocialRquest(_ info: SocialBodyParameters) {
        repo?.socialLogin(info) { [weak self] result in
            guard let self = self else { return }
            self.handelResponse(result)
        }
    }
}

// MARK: - Facebook

extension LoginViewModel: FacebookLoginHelperDelegate {
    func didAuthenticate(info: SocialBodyParameters) {
        fireSocialRquest(info)
    }

    func didFail(with error: Error) {
        requestError?.value = .messageError(error.localizedDescription)
    }
}

// MARK: - Google

extension LoginViewModel: GoogleLoginHelperDelegate {
    func didAuthenticate(with info: SocialBodyParameters) {
        fireSocialRquest(info)
    }
}

// MARK: - Apple

extension LoginViewModel: AppleLoginHelperDelegate {
    func didFetchAppleAccountData(with info: Parameters) {
        repo?.socialLogin(info) { [weak self] result in
            guard let self = self else { return }
            self.handelResponse(result)
        }
    }
}

protocol LoginVMProtocol: ViewModel {
    func updateParameters(_ field: LoginField)
    func login()
    func continueAsGuest()
    func register()
    func forgetPass()
    func navigateToHome()
    func faceboockLoginTapped()
    func gmailButtonTapped()
    func appleButtonTapped()
}
//func continueAsGuest() {
//    navigateToHome()
//}
//    func navigateToHome() {
//        coordinator?.pop(false)
//        coordinator?.parent?.start()
//    }
//
//    func register() {
//        coordinator?.navigateTo(AuthDestination.register)
//    }
enum LoginField {
    case email(String)
    case password(String)
}

struct LoginParams: Parameters {
    var email: String = ""
    var password: String = ""
    var socialId: String = ""
    var socialType: String = ""

    var body: [String: Any] {
        return ["email": email, "password": password, "social_id": socialId, "social_type": socialType]
    }
}

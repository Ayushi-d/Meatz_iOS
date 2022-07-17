//
//  RegisterViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/8/21.
//

import Foundation
import UIKit


final class RegisterViewModel {
    private var coordinator: Coordinator?
    private var repo: RegisterRepoProtocol?
    private var parameters: RegisterParams = RegisterParams()

    var onRequestCompletion: ((String?) -> Void)?
    var state: State = .notStarted
    var requestError: Observable<ResultError>? = Observable(nil)
    var isTermsAccepted: Observable<Bool> = Observable(false)
    init(_ repo: RegisterRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

// MARK: - ViewModel functionality

extension RegisterViewModel: RegisterVMProtocol {
    func register() {
        guard validateParams() else{return}
        repo?.register(parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.state = .success
                self.cachUser(model.user)
                guard let completion = self.onRequestCompletion else { return }
                completion(model.message)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }
    fileprivate func cachUser(_ user: User){
        guard CachingManager.shared.cache(user) else{
            requestError?.value = .messageError(R.string.localizable.somethingWenWrong())
            return
        }
    }
    func signIn() {
        coordinator?.pop(true)
    }
    fileprivate func validateParams() -> Bool {
        guard !parameters.firstName.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourFirstName())
            return false
        }
        guard !parameters.lastName.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourLastName())
            return false
        }
        guard !parameters.email.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourEmail())
            return false
        }
        guard parameters.email.isValidEmail() else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterAValidEmail())
            return false
        }
        guard !parameters.mobile.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourPhone())
            return false
        }
        guard parameters.mobile.count == 8 else {
            requestError?.value = .messageError(R.string.localizable.phoneLengthValidation())
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

        guard !parameters.passConfimation.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterConfirmedPassword())
            return false
        }

        guard parameters.password.elementsEqual(parameters.passConfimation) else {
            requestError?.value = .messageError(R.string.localizable.passMatching())
            return false
        }

        guard isTermsAccepted.value! else {
            requestError?.value = .messageError(R.string.localizable.termsAcceptValidation())
            return false
        }
        return true
    }

    func didRegisterSuccessfully() {
        coordinator?.parent?.start()
    }
    func updateParams(_ field: RegisterField) {
        switch field {
        case .fname(let value):
            parameters.firstName = value
        case .lname(let value):
            parameters.lastName = value
        case .email(let value):
            parameters.email = value
        case .mobile(let value):
            parameters.mobile = value
        case .pass(let value):
            parameters.password = value
        case .passConfirm(let value):
            parameters.passConfimation = value
        }
    }
    
    func showTerms() {
        coordinator?.navigateTo(AuthDestination.terms)
    }
}

// MARK: - ViewModel Protocol

protocol RegisterVMProtocol: ViewModel {
    var isTermsAccepted: Observable<Bool> { get set }
    func register()
    func signIn()
    func updateParams(_ field: RegisterField)
    func didRegisterSuccessfully()
    func showTerms()
}

// MARK: - Parameters & Field Type

struct RegisterParams: Parameters {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var mobile: String = ""
    var password: String = ""
    var passConfimation: String = ""
    var body: [String: Any] {
        return ["first_name": firstName,
                "last_name": lastName,
                "email": email,
                "mobile": mobile,
                "password": password]
    }
}

enum RegisterField {
    case fname(String)
    case lname(String)
    case email(String)
    case mobile(String)
    case pass(String)
    case passConfirm(String)
}

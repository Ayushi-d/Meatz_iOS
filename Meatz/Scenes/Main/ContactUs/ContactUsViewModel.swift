//
//  ContactUsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import Foundation

final class ContactUsViewModel {
    private var repo: ContactUsRepoProtocol?
    private var contactInfo: ContactInfoModel?
    private var coordinator : Coordinator?
    var onRequestCompletion: ((_ message: String?) -> Void)?
    var state: State = .notStarted
    var requestError: Observable<ResultError>? = Observable(nil)
    var parameters = ContactUsParams()

    init(_ repo: ContactUsRepoProtocol?, contactInfo: ContactInfoModel?,coordinator : Coordinator?) {
        self.repo = repo
        self.contactInfo = contactInfo
        self.coordinator = coordinator
    }
}

// MARK: - Request

extension ContactUsViewModel {
    func sendMessage() {
        guard isValidInputs() else { return }
        repo?.contactUs(parameters) { [weak self] result in
            guard let self = self else { return }
            self.responseHandeler(result)
        }
    }

    private func isValidInputs() -> Bool {
        guard !parameters.name.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourName())
            return false
        }

        guard parameters.email.isValidEmail() else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterAValidEmail())
            return false
        }

        guard parameters.phone.count == 8 else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterAValidPhoneNumber8DigitsOnly())
            return false
        }

        guard !parameters.message.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourMessage())
            return false
        }
        return true
    }
}

// MARK: - Handel Response

extension ContactUsViewModel: ContactUsVMProtocol {
    private func responseHandeler(_ result: Result<SuccessModel, ResultError>) {
        switch result {
        case .success(let model):
            guard let completion = onRequestCompletion else { return }
            completion(model.message)
        case .failure(let error):
            requestError?.value = error
        }
    }
    
    func popToSetting() {
        coordinator?.pop(true)
    }
}

// MARK: - VM Protocol Imp

extension ContactUsViewModel {
    func updateFields(_ Fileds: ContactUsItems) {
        switch Fileds {
        case .name(let value):
            parameters.name = value ?? ""
        case .email(let value):
            parameters.email = value ?? ""
        case .phone(let value):
            parameters.phone = value ?? ""
        case .message(let value):
            parameters.message = value ?? ""
        }
    }
    
    var whatspp: String{
        return contactInfo?.whatsapp ?? ""
    }
}

// MARK: - VM PRotocol

protocol ContactUsVMProtocol: ViewModel {
    var whatspp: String {get}
    func sendMessage()
    func popToSetting()
    func updateFields(_ Fileds: ContactUsItems)
}

enum ContactUsItems {
    case name(String?)
    case email(String?)
    case phone(String?)
    case message(String?)
}

struct ContactUsParams: Parameters {
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var message: String = ""

    var body: [String: Any] {
        return ["name": name, "mobile": phone, "email": email, "message": message]
    }
}

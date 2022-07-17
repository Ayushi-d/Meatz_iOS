//
//  ForgotPassViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/11/21.
//

import Foundation

final class ForgotPassViewModel {
    private var repo: ForgotPassRepoProtocol?
    private var coordinator: Coordinator?
    private var parameters: ForgetPassParams = ForgetPassParams()
    var requestError: Observable<ResultError>? = Observable(nil)
    var onRequestCompletion: ((String?) -> Void)?
    var state: State = .notStarted
    init(_ repo: ForgotPassRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension ForgotPassViewModel: ForgotPassVMProtocol {
    func send(_ email: String) {
        guard isValid(email) else { return }
        parameters.email = email
        repo?.sendPass(parameters) { [weak self] res in
            guard let self = self else { return }
            switch res {
            case .success(let model):
                self.state = .success
                guard let completion = self.onRequestCompletion else { return }
                completion(model.message)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }

    private func isValid(_ email: String) -> Bool {
        guard !email.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourEmail())
            return false
        }
        guard email.isValidEmail() else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterAValidEmail())
            return false
        }
        return true
    }
    
    func back() {
        coordinator?.pop(true)
    }
}

protocol ForgotPassVMProtocol: ViewModel {
    func send(_ email: String)
    func back()
}

struct ForgetPassParams: Parameters {
    var email: String = ""
    var body: [String: Any] {
        return ["email": email]
    }
}

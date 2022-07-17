//
//  EditProfileViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/11/21.
//

import Foundation

class EditProfileViewModel {
    var repo: ProfileRepoProtocol?
    var coordinator: Coordinator?
    var parameter = EditProfileParams()
    var state: State = .notStarted
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable(nil)
    init(_ repo: ProfileRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }

    func update() {
        guard isValid() else { return }
        repo?.updateProfile(parameter) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
               // self.profileInfoModel = model
                self.state = .success
                guard let completion = self.onRequestCompletion else { return }
                completion(model.message)
                self.cachUser(model.user)
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

    func isValid() -> Bool {
        guard !parameter.firstName.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourFirstName())
            return false
        }
        guard !parameter.lastName.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourLastName())
            return false
        }
        guard !parameter.mobile.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourPhone())
            return false
        }
        guard parameter.mobile.count == 8 else {
            requestError?.value = .messageError(R.string.localizable.phoneLengthValidation())
            return false
        }
        return true
    }

    func updateParams(_ field: ProfileField) {
        switch field {
        case .firstName(let value):
            print(value)
            parameter.firstName = value ?? ""
        case .lastName(let value):
            parameter.lastName = value ?? ""
        case .mobile(let value):
            parameter.mobile = value ?? ""
        }
    }
}

extension EditProfileViewModel: EditProfileVMProtocol {
    func popToProfile() {
        coordinator?.pop(true)
    }
}

protocol EditProfileVMProtocol: ViewModel {
    func updateParams(_ field: ProfileField)
    func update()
    func popToProfile()
}

// MARK: - Edit Profile parameters

enum ProfileField {
    case firstName(String?)
    case lastName(String?)
    case mobile(String?)
}

struct EditProfileParams: Parameters {
    var firstName: String = ""
    var lastName: String = ""
    var mobile: String = ""
    var email: String = ""

    var body: [String: Any] {
        return ["first_name": firstName,
                "last_name": lastName,
                "mobile": mobile,
                "email": CachingManager.shared.getUser()?.email ?? ""]
    }
}

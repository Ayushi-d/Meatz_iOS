//
//  ChangePassViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/12/21.
//

import Foundation

final class ChangePassViewModel{
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable.init(nil)
    var state: State = .notStarted
    private var repo : ChangePassRepoProtocol?
    private var coordinator : Coordinator?
    private var parameters : ChangePassParams = ChangePassParams()
    init(_ repo :ChangePassRepoProtocol?,_ coordinator : Coordinator? ) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

//MARK:- Functionality 
extension ChangePassViewModel : ChangePassVMProtocol{
    func changePass() {
        guard isValid() else{return}
        repo?.changePass(parameters, { [weak self] (result) in
            guard let self = self else{return}
            switch result{
            case .success(let model):
                self.state = .success
                guard let completion = self.onRequestCompletion else{return}
                completion(model.message)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
    
    func updateParams(_ field: ChangePassField) {
        switch field{
        case .oldPass(let value):
            parameters.oldPass = value
        case .newPass(let value):
            parameters.newPass = value
        case .confirmPass(let value):
            parameters.confirmPass = value
        }
    }
    
    fileprivate func isValid() -> Bool{
        guard parameters.oldPass.count >= 8 else{
            requestError?.value = .messageError(R.string.localizable.pleaseEnterOldPassword())
            return false
        }
        guard parameters.newPass.count >= 8 else{
            requestError?.value = .messageError(R.string.localizable.pleaseEnterNewPassword())
            return false
        }
        guard parameters.confirmPass.count >= 8 else{
            requestError?.value = .messageError(R.string.localizable.pleaseEnterNewConfirmedPassword())
            return false
        }
        guard parameters.newPass.elementsEqual(parameters.confirmPass) else{
            requestError?.value = .messageError(R.string.localizable.passMatching())
            return false
        }
        return true
    }
    
    func presentSuccessAlert() {
        coordinator?.present(MainDestination.changePassAlert)
    }
}


protocol ChangePassVMProtocol : ViewModel{
    func changePass()
    func presentSuccessAlert()
    func updateParams(_ field : ChangePassField)
}


//MARK:- Parameters

enum ChangePassField{
    case oldPass(String)
    case newPass(String)
    case confirmPass(String)
}
struct ChangePassParams : Parameters{
    var oldPass : String = ""
    var newPass : String = ""
    var confirmPass : String = ""
    
    var body: [String : Any]{
        return ["old_password" : oldPass,"password": newPass]
    }
}

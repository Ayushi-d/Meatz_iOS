//
//  EditProfileWithPhoneViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/25/21.
//

import Foundation

final class EditProfileWithPhoneViewModel: EditProfileViewModel {
    
    var model : CartDataModel?
    
    override func update() {
        guard isValid() else { return }

        repo?.updateProfile(parameter) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                //self.profileInfoModel = model
                self.state = .success
                guard let completion = self.onRequestCompletion else { return }
                completion(model.message)
                self.cachUser(model.user)
                print(model.user)
                self.coordinator?.dismiss(true, nil)
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
    
    func continueToCheckout(){
        guard let model_ = model else{return}
        coordinator?.navigateTo(MainDestination.checkout(model_))
    }
}

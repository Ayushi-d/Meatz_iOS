//
//  EditProfileWithPhoneController.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/25/21.
//

import UIKit

class EditProfileWithPhoneController: UIViewController {
    var viewModel: EditProfileWithPhoneViewModel!
    
    @IBOutlet weak var phoneTF: BaseTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onError()
        onCompletion()
        observeInput()
    }
    
    fileprivate func observeInput() {
        self.viewModel.updateParams(.firstName(CachingManager.shared.getUser()?.firstName ?? ""))
        self.viewModel.updateParams(.lastName(CachingManager.shared.getUser()?.lastName ?? ""))
        phoneTF?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParams(.mobile(text ?? ""))
        }
    }
    
    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.hideActivityIndicator()
            self.showToast("", err.describtionError, completion: nil)
        }
    }

    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] message in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.showDialogue(R.string.localizable.profileUpdated(),
                              message ?? "",
                              R.string.localizable.ok().uppercased()) {
                self.viewModel.continueToCheckout()
            }
        }
    }

    @IBAction func addButtonAction(_ sender: Any) {
        showActivityIndicator()
        viewModel.update()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

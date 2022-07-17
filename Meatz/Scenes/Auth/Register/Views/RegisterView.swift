//
//  RegisterView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/8/21.
//

import UIKit

final class RegisterView: UIViewController {
    @IBOutlet private var firstNameTextField: BaseTextField?
    @IBOutlet private var lastNameTextField: BaseTextField?
    @IBOutlet private var emailTextField: BaseTextField?
    @IBOutlet private var phoneTextField: BaseTextField?
    @IBOutlet private var passwordTextField: BaseTextField?
    @IBOutlet private var passwordConfirmTextField: BaseTextField?
    @IBOutlet weak var phoneIcon: UIImageView!
    
    var viewModel: RegisterVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        onError()
        onCompletion()
        observeInput()
        phoneIcon.image = #imageLiteral(resourceName: "telephone").imageFlippedForRightToLeftLayoutDirection()
    }

    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] message in
            guard let self = self else { return }
            if let msg = message {
                self.showDialogue(R.string.localizable.confirmation(), msg, R.string.localizable.ok().uppercased()) { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.didRegisterSuccessfully()
                }
            }
        }
    }

    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            if let err = error {
                self.showMessage(err.describtionError)
            }
        }
    }

    fileprivate func showMessage(_ msg: String) {
        hideActivityIndicator()
        showToast("", msg, completion: nil)
    }

    fileprivate func observeInput() {
        firstNameTextField?.observe = { [weak self] txt in
            guard let self = self else { return }
            self.viewModel.updateParams(.fname(txt ?? ""))
        }
        lastNameTextField?.observe = { [weak self] txt in
            guard let self = self else { return }
            self.viewModel.updateParams(.lname(txt ?? ""))
        }
        emailTextField?.observe = { [weak self] txt in
            guard let self = self else { return }
            self.viewModel.updateParams(.email(txt ?? ""))
        }
        phoneTextField?.observe = { [weak self] txt in
            guard let self = self else { return }
            self.viewModel.updateParams(.mobile(txt ?? ""))
        }
        passwordTextField?.observe = { [weak self] txt in
            guard let self = self else { return }
            self.viewModel.updateParams(.pass(txt ?? ""))
        }
        passwordConfirmTextField?.observe = { [weak self] txt in
            guard let self = self else { return }
            self.viewModel.updateParams(.passConfirm(txt ?? ""))
        }
    }
}

// MARK: - Actions

extension RegisterView {
    @IBAction func acceptTerms(_ sender: UIButton) {
        let updatedFlag = !viewModel.isTermsAccepted.value!
        viewModel.isTermsAccepted.value = updatedFlag
        let img = updatedFlag ? R.image.filterCheckBox() : R.image.iconMaterialCheckBoxOutlineBlank()
        sender.setBackgroundImage(img, for: .normal)
    }

    @IBAction func showTerms(_ sender: UIButton) {
        viewModel.showTerms()
    }
    @IBAction func register(_ sender: UIButton) {
        showActivityIndicator()
        viewModel.register()
    }

    @IBAction func signIn(_ sender: UIButton) {
        viewModel.signIn()
    }
}

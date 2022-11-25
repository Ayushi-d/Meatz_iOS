//
//  LoginView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/7/21.
//

import UIKit

final class LoginView: UIViewController {
    @IBOutlet private var passwordTextField: BaseTextField?
    @IBOutlet private var emailTextField: BaseTextField?
    var viewModel: LoginVMProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        observeInput()
        onCompletion()
        onError()
    }

    fileprivate func onError() {
        viewModel?.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            self.showMessage(error?.describtionError ?? "")
        }
    }

    fileprivate func onCompletion() {
        viewModel?.onRequestCompletion = { [weak self] message in
            guard let self = self else { return }
            self.showMessage(message ?? "")
        }
    }

    fileprivate func showMessage(_ msg: String) {
        hideActivityIndicator()
        showToast("", msg, completion: {[weak self] in
            guard let self = self else{return}
            if self.viewModel?.state == .success{
                self.viewModel?.navigateToHome()
            }
        })
    }

    fileprivate func observeInput() {
        emailTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel?.updateParameters(.email(text ?? ""))
        }

        passwordTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel?.updateParameters(.password(text ?? ""))
        }
    }
}

// MARK: - Actions

extension LoginView {
    @IBAction func loginPressed(_ sender: UIButton) {
        showActivityIndicator()
        viewModel?.login()
    }

    @IBAction func forgotPassPressed(_ sender: UIButton) {
        viewModel?.forgetPass()
    }

    @IBAction func loginWithApple(_ sender: UIButton) {
        viewModel?.appleButtonTapped()
    }

    @IBAction func loginWithFB(_ sender: UIButton) {
        viewModel?.faceboockLoginTapped()
    }

    @IBAction func loginWithGoogle(_ sender: UIButton) {
        viewModel?.gmailButtonTapped()
    }

    @IBAction func registerNow(_ sender: UIButton) {
        viewModel?.register()
    }

    @IBAction func continueAsGuest(_ sender: UIButton) {
        viewModel?.continueAsGuest()
    }
}

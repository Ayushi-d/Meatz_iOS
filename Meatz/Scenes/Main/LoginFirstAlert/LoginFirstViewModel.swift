//
//  LoginFirstViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//

import Foundation
final class LoginFirstAlertViewModel {
    private var coordinator: Coordinator?
    init(_ coordinator: Coordinator?) {
        self.coordinator = coordinator
    }
}

extension LoginFirstAlertViewModel: LoginFirstAlertVMProtocol {
    func dismiss() {
        coordinator?.dismiss(true, nil)
    }
    
    func signIn() {
        dismiss()
        let authCrd = AuthCoordinator(coordinator!.navigationController)
        authCrd.start()
        authCrd.parent = coordinator
    }
}

protocol LoginFirstAlertVMProtocol: class {
    func signIn()
}

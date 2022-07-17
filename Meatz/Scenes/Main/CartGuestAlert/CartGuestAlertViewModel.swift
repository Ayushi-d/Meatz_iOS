//
//  CartGuestAlertViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//

import Foundation
final class CartGuestAlertViewModel {
    private var coordinator: Coordinator?
    private var cartModel:CartDataModel?
    init(_ coordinator: Coordinator?,cartModel:CartDataModel?) {
        self.coordinator = coordinator
        self.cartModel = cartModel
    }
}

extension CartGuestAlertViewModel: CartGuestAlertVMProtocol {
    func dismiss() {
        coordinator?.dismiss(true, nil)
    }
    
    func continueAsGuest() {
        guard let model = cartModel else {return}
        coordinator?.navigateTo(MainDestination.deliveryAddress(model))
        dismiss()
    }
    
    func signIn() {
        dismiss()
        let authCrd = AuthCoordinator(coordinator!.navigationController)
        authCrd.start()
        authCrd.parent = coordinator
    }
}

protocol CartGuestAlertVMProtocol: class {
    func dismiss()
    func continueAsGuest()
    func signIn()
}

//
//  GuestAlertController.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//

import UIKit

class GuestAlertController: UIViewController {
    private var viewModel: CartGuestAlertVMProtocol?
    func setViewModel(_ viewModel: CartGuestAlertVMProtocol?) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func continueShoppingAction(_ sender: Any) {
        viewModel?.dismiss()
    }

    @IBAction func continueAsGuestAction(_ sender: Any) {
        viewModel?.continueAsGuest()
    }

    @IBAction func signInAction(_ sender: Any) {
        viewModel?.signIn()
    }
}

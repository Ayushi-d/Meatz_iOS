//
//  LoginFirstAlertController.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//

import UIKit

class LoginFirstAlertController: UIViewController {
    var coordinator: Coordinator?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: Any) {
        dismiss()
        let authCrd = AuthCoordinator(coordinator!.navigationController)
        authCrd.start()
        authCrd.parent = coordinator
    }

    func dismiss() {
        coordinator?.dismiss(true, nil)
    }
}

//
//  ChangePassAlertController.swift
//  Meatz
//
//  Created by Nabil Elsherbene on 5/4/21.
//

import UIKit

class ChangePassAlertController: UIViewController {
    weak var coordinator: Coordinator?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func loginAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        CachingManager.shared.removeCurrentUser()
        let authCrd = AuthCoordinator(coordinator!.navigationController)
        authCrd.start()
        authCrd.parent  = coordinator
    }
    

}

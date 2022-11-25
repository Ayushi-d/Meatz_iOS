//
//  ErrorRecharegeWalletView.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/23/21.
//

import UIKit

class ErrorRecharegeWalletView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tryAginButtonTapped(_ sender: UIButton) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.popTo(WalletView.self)
    }
    
}

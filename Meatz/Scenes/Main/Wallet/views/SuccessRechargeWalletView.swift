//
//  SuccessRechargeWalletView.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/23/21.
//

import UIKit

class SuccessRechargeWalletView: UIViewController {
    
    @IBOutlet weak var rechargeAmountLabel: MediumLabel!
    @IBOutlet weak var transitionIdLabel: MediumLabel!
    @IBOutlet weak var paymentIdLabel: MediumLabel!
    
    
    var viewModel: SucsessVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        rechargeAmountLabel.text = viewModel.model.rechargeAmount + " " + R.string.localizable.kwd()
        transitionIdLabel.text = viewModel.model.transID
        paymentIdLabel.text = viewModel.model.paymentID
    }
    
    @IBAction func myWalletButtonTapped(_ sender: UIButton) {
        viewModel.myWallet()
    }
    
}

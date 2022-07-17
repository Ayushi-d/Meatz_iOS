//
//  SucsessRechargeWallet.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/23/21.
//

import Foundation

class SucsessRechargeWalletViewModel: SucsessVMProtocol {

    private var model: CheckoutModel
    private var coordinator : Coordinator?
    
    init(model : CheckoutModel, _ coordinator : Coordinator?) {
        self.model = model
        self.coordinator = coordinator
    }
    
}

protocol SucsessVMProtocol {
    
}

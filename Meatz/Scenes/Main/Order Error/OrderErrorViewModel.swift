//
//  OrderErrorViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/26/21.
//

import Foundation

final class OrderErrorViewModel {
    private var coordinator : Coordinator?
    
    init(_ coordinator : Coordinator?) {
        self.coordinator = coordinator
    }
}

extension OrderErrorViewModel: OrderErrorVMProtocol{
    func tryAgain() {
        coordinator?.navigateTo(MainDestination.popToCheckout)
    }
}


protocol OrderErrorVMProtocol{
    func tryAgain()
}

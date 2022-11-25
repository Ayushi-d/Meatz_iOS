//
//  OrderSuccessViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/26/21.
//

import Foundation

final class OrderSuccessViewModel {
    private var coordinator : Coordinator?
    private var model : CheckoutModel?
    init(_ model : CheckoutModel ,_ coordinator : Coordinator?) {
        self.coordinator = coordinator
        self.model = model
    }
}

extension OrderSuccessViewModel : OrderSuccessVMProtocol{
    var isCash: Bool {
        return (model?.paymentURL ?? "").isEmpty
    }
    
    var orderID: String {
        return "# " + (model?.orderID ?? 0).toString
    }
    
    var transactionID: String {
        return model?.transID ?? ""
    }
    
    var paymentID: String {
        return model?.paymentID ?? ""
    }
    
    func myOrders() {
        coordinator?.navigateTo(MainDestination.orders(true))
    }
    
    func navigateToHome() {
//        let navigationVC = MainNavigationController()
//        let mainCrd = MainCoordinator(navigationVC)
//        mainCrd.start()
//        //mainCrd.parent = (viewModel as? AdsViewModel)?.coordinator
//        appWindow?.rootViewController = navigationVC
       // coordinator?.pop(false)
       // coordinator?.parent?.start()
       // coordinator?.start()
        //coordinator?.navigationController.popToRootViewController(animated: false)
    }
}


protocol OrderSuccessVMProtocol{
    var isCash : Bool{get}
    var orderID : String{get}
    var transactionID : String{get}
    var paymentID : String{get}
    
    func navigateToHome()
    func myOrders()
}

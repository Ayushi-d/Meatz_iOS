//
//  PaymentViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/26/21.
//

import Foundation

final class PaymentViewModel{
    
    var requestError: Observable<ResultError>? = Observable(nil)
    private var coordinator : Coordinator?
    private var model : CheckoutModel?
    
    
    init(_ model : CheckoutModel,_ coordinator : Coordinator?) {
        self.coordinator = coordinator
        self.model = model
    }
}

extension PaymentViewModel : PaymentVMProtocol{
    var paymentLink: URL?{
        let linkString = model?.paymentURL ?? ""
        return URL(string: linkString)
    }
    
    func showSuccessView() {
        guard let model_ = model else{return}
        switch model_.paymentType {
        case.checkout:
            coordinator?.navigateTo(MainDestination.checkoutSuccess(model_))
        case .rechargeWallet:
            coordinator?.navigateTo(MainDestination.successRechageWallet(model: model_))
        }
        
    }
    
    func showErrorView() {
        switch model?.paymentType {
        case .checkout:
            coordinator?.navigateTo(MainDestination.checkoutError)
        case .rechargeWallet:
            coordinator?.navigateTo(MainDestination.errorRechargeWallet)
        default:
            break
        }
        
    }
    
    func parsePaymentURL(_ url: String) {
//        let urlComponent = NSURLComponents(string: url)
//        let transID = urlComponent?.getParametersValueForKey("Id") ?? ""
//        let paymentID = urlComponent?.getParametersValueForKey("paymentId") ?? ""
//        model?.paymentID = paymentID
//        model?.transID = transID
        
        //New parse
        HomeApi.parsePayment(url).sendRequst(data: PaymentResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let paymentData = PaymentModel(response)
                self.model?.paymentID = paymentData.paymentId
                self.model?.transID = paymentData.transactionID
                self.model?.orderID = paymentData.orderId
                self.showSuccessView()
            case .failure(let error):
                self.requestError?.value = error
            }
        }
        
    }
}

protocol PaymentVMProtocol{
    var requestError: Observable<ResultError>? { get set }
    var paymentLink : URL?{get}
    func showSuccessView()
    func showErrorView()
    func parsePaymentURL(_ url : String)
}

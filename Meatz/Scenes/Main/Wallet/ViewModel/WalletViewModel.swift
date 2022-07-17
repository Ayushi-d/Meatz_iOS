//
//  WalletViewModel.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/22/21.
//

import Foundation

class WalletViewModel: WalletRepoVMProtocol {
    
    
    var message: Observable<String> = Observable("")
    var state: State = .notStarted
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>?
    var showError: Observable<Error> = Observable(ResultError(0, error: ""))
    
    var rechargePackages: [RechargePackageModel] = []
    var balance: String = ""
    private var walletParameters =  WalletParameter()
    var showIndocator: Observable<Bool> = Observable(false)
    
    private var repo: WalletRepoProtocol
    private var coordinator: Coordinator?
    private var parameterModel: CheckoutModel!
    
    init(_ repo: WalletRepoProtocol, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
    
    var numberOfPackages: Int {
        return rechargePackages.count
    }
    
    func onViewDidLoad() {
        repo.getWallet { [weak self] result  in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.state = .success
                self.rechargePackages = model.packages
                self.balance = model.balance
                guard let completion = self.onRequestCompletion else { return }
                completion(nil)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }
    
    func getPackageModel(at index: Int) -> RechargePackageModel {
        return rechargePackages[index]
    }
    
    
    
    func rechargeAmount(amount: String) {
        guard !amount.isEmpty else {
            message.value = R.string.localizable.pleaseEnterTheChargeValue()
            return
        }
        walletParameters.type = .amount
        walletParameters.amount = amount
        recharge()
    }
    
    func rechargePackage(at index: Int) {
        walletParameters.type = .package
        walletParameters.amount = rechargePackages[index].allPrice
        walletParameters.cartId = rechargePackages[index].id
        recharge()
    }
    
    private func recharge() {
        self.showIndocator.value = true
        repo.rechargeWallet(walletParameters) { [weak self] result in
            guard let self = self else { return }
            self.showIndocator.value = false
            switch result {
            case .success(let model):
                self.parameterModel = model
                self.navigateToPayment()
            case .failure(let error):
                self.requestError?.value = error
                self.message.value = error.describtionError
                self.state = .finishWithError(error)
            }
        }
    }
    
    private func navigateToPayment() {
        parameterModel.rechargeAmount = walletParameters.amount
        parameterModel.paymentType = .rechargeWallet
        coordinator?.navigateTo(MainDestination.payment(parameterModel))
    }

}

protocol WalletRepoVMProtocol: ViewModel {
    var showIndocator: Observable<Bool> { get set }
    var message: Observable<String> { get set }
    var numberOfPackages: Int { get }
    var balance: String { get set }
    var showError: Observable<Error> { get set }
    func onViewDidLoad()
    func getPackageModel(at index: Int) -> RechargePackageModel
    func rechargePackage(at index: Int)
    func rechargeAmount(amount: String)
}

struct WalletParameter: Parameters {
    
    var amount: String = ""
    var cartId: Int = 0
    var type: RechargeType = .amount
    
    var body: [String : Any] {
        switch type {
        case .amount:
            return ["amount": amount]
        case .package:
            return ["card_id": cartId]
        }
    }
}
 
enum RechargeType {
    case package
    case amount
}

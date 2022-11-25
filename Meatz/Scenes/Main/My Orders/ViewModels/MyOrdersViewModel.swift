//
//  MyOrdersViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/15/21.
//

import Foundation

final class MyOrdersViewModel {
    var state: State = .notStarted
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable.init(nil)
    private var repo : MyOrdersRepoProtocol?
    private var coordinator : Coordinator?
    private var orders : [MyOrderModel] = []
    var pushedFromOrderState:Bool = false
    init(_ repo : MyOrdersRepoProtocol?,_ coordinator : Coordinator?,pushedFromOrderState:Bool) {
        self.repo = repo
        self.pushedFromOrderState = pushedFromOrderState
        self.coordinator = coordinator
    }
}

extension MyOrdersViewModel : MyOrdersVMProtocol{
    var numberOfOrders: Int{
        return orders.count
    }
    func onViewDidLoad() {
        repo?.getOrders({[weak self] (result) in
            guard let self = self else{return}
            switch result{
            case .success(let model):
                self.orders = model.orders
                self.state = .success
                guard let completion = self.onRequestCompletion else{return}
                completion("")
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
    
    func didSelectOrder(at index: Int) {
        let id = orders[index].id
        coordinator?.navigateTo(MainDestination.orderDetails(id))
    }
    
    func viewModelForOrder(at index: Int) -> MyOrdersCellViewModel {
        return orders[index]
    }
    
    func didReordered(_ id: Int) {
        repo?.reorder(id, compleiton: { [weak self](result) in
            switch result{
            case .success(let model):
                self?.coordinator?.navigateTo(MainDestination.checkout(model))
                guard let completion = self?.onRequestCompletion else{return}
                completion("")
            case .failure(let error):
                self?.requestError?.value = error
            }
        })
    }
}


protocol MyOrdersVMProtocol : ViewModel , Reorderable{
    var numberOfOrders : Int{get}
    var pushedFromOrderState:Bool {get}
    func onViewDidLoad()
    func didSelectOrder(at index : Int)
    func viewModelForOrder(at index : Int) -> MyOrdersCellViewModel
    
}

//
//  OrderDetailsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/17/21.
//

import Foundation

final class OrderDetailsViewModel {
    var showCancelDialog: Observable<String> = Observable("")
    var state: State = .notStarted
    var orderID: Int = 0
    var orderInfo: Observable<OrderDetailsModel> = Observable(nil)
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable(nil)
    private var repo: OrderDetailsRepoProtocol?
    private var coordinator: Coordinator?
    private var items: [OrderProductModel] = []
    init(_ repo: OrderDetailsRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension OrderDetailsViewModel: OrderDetailsVMProtocol {
    
    var guestAddress:String{
        return orderInfo.value?.address.guestAddress ?? ""
    }
    
    
    var numberOfItems: Int {
        return items.count
    }

    func onViewDidLoad() {
        repo?.getOrder(with: orderID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.state = .success
                self.items = model.products
                self.orderInfo.value = model
                guard let completion = self.onRequestCompletion else { return }
                completion("")
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }

    func viewModelForCell(at index: Int) -> OrderProductCellViewModel {
        return items[index]
    }

    func reorder() {
        repo?.reorder(orderID, compleiton: { [weak self] result in
            switch result {
            case .success(let model):
                self?.coordinator?.navigateTo(MainDestination.checkout(model))
                guard let completion = self?.onRequestCompletion else { return }
                completion("")
            case .failure(let error):
                self?.requestError?.value = error
            }
        })
    }
    
    func cancelOrder() {
        repo?.cancelOrder(with: orderID, { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.state = .success
                self.items = model.products
                self.orderInfo.value = model
                self.showCancelDialog.value = model.message
                guard let completion = self.onRequestCompletion else { return }
                completion("")
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
}

protocol OrderDetailsVMProtocol: ViewModel {
    var orderInfo: Observable<OrderDetailsModel> { get set }
    var showCancelDialog: Observable<String> { get set }
    var numberOfItems: Int { get }
    var guestAddress:String {get}
    func onViewDidLoad()
    func viewModelForCell(at index: Int) -> OrderProductCellViewModel
    func reorder()
    func cancelOrder()
}

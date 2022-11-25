//
//  BoxProductsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/15/21.
//

import Foundation

final class BoxProductsViewModel {
    private var repo: BoxProductsRepoProtocol?
    private var coordinator: Coordinator?
    private var myBoxes: [BoxesDataModel] = []
    private var boxId: Int = 0
    private var products = [ProductModel]()
    var isThereItemsDeleted: Observable<Bool> = Observable.init(false)
    var onRequestCompletion: ((String?) -> Void)?
    var model: Observable<BoxProductsModel> = Observable(nil)
    var requestError: Observable<ResultError>? = Observable(nil)
    var state: State = .notStarted
    var parameters = deleteProductParams()
    var deletedItems: [String] = []
    private(set) var contactnto: ContactInfoModel?

    init(repo: BoxProductsRepoProtocol?, _ coordinator: Coordinator?, boxId: Int) {
        self.repo = repo
        self.coordinator = coordinator
        self.boxId = boxId
    }
}

// MARK: - Request

extension BoxProductsViewModel {
    func viewDidLoad() {
        self.repo?.didRecieveProducts(with: self.boxId) { [weak self] result in
            guard let self = self else { return }
            self.responseHandeler(result)
        }
    }
}

// MARK: - Handel Response

extension BoxProductsViewModel {
    private func responseHandeler(_ result: Result<BoxProductsModel, ResultError>) {
        switch result {
        case .success(let model):
            self.products = model.product
            self.model.value = model
            guard let completion = self.onRequestCompletion else { return }
            completion(model.message)
        case .failure(let error):
            self.requestError?.value = error
        }
    }
}

// MARK: - VMImpl

extension BoxProductsViewModel: BoxProductsVMProtocol {
    var numberOfProducts: Int {
        return self.products.count
    }

    func dequeCellForRow(at index: IndexPath) -> ProductModel {
        return self.products[index.row]
    }
}

// MARK: - Delete Item Impl

extension BoxProductsViewModel: DeleteItemProtocol {
    func didTapDeleteButton<T>(item: T) {
        if let item_ = item as? ProductModel , let completion = onRequestCompletion{
            products = products.filter({return $0.id != item_.id})
            isThereItemsDeleted.value = true
            completion("")
            guard !self.deletedItems.contains(item_.id.toString) else { return } /// check if deleted array containt new element id will be adding or not and retrun if that
            self.deletedItems.append(item_.id.toString)
            let deletedItems_ = self.deletedItems.map { $0 }.joined(separator: ",")
            self.parameters.productID = deletedItems_
            print(deletedItems_)
        }
    }

    func deleteItem() {
        let boxId = self.model.value?.header.boxId ?? 0
        self.repo?.deletItem(with: boxId, self.parameters) { [weak self] result in
            guard let self = self else { return }
            self.responseHandeler(result)
            self.deletedItems = []
            self.viewDidLoad()
        }
    }
}

// MARK: - VM Protocol

protocol BoxProductsVMProtocol: ViewModel {
    var numberOfProducts: Int { get }
    var model: Observable<BoxProductsModel> { get set }
    var isThereItemsDeleted : Observable<Bool>{get set}
    func viewDidLoad()
    func dequeCellForRow(at index: IndexPath) -> ProductModel
    func deleteItem()
}

struct deleteProductParams: Parameters {
    var productID: String = ""
    var body: [String: Any] {
        return ["product_id": self.productID]
    }
}

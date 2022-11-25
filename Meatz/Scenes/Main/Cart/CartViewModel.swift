//
//  CartViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//

import Foundation

final class CartViewModel {
    var showIndicator: Observable<Bool> = Observable(false)
    private var repo: CartRepoProtocol?
    private var coordinator: Coordinator?
    private var params = AddItemToBoxesParameters()
    var onRequestCompletion: ((String?) -> Void)?
    var model: Observable<CartDataModel> = Observable(nil) // ********Cart Model
    var requestError: Observable<ResultError>? = Observable(nil)
    var state: State = .notStarted
    var parameters = deleteProductParams()
    var itemType: CartItemType = .box
    var clearUnavlibleItemFromCartParam = clearUnAvailbleItemFromCartParams()

    init(repo: CartRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

// MARK: - Request

extension CartViewModel {
    func viewDidLoad() {
        self.repo?.didRecieveCartItems(nil) { [weak self] result in
            guard let self = self else { return }
            self.responseHandeler(result)
        }
    }
    
    func clearUnAvailableItemsFromCart(){
        self.repo?.didRecieveCartItems(clearUnavlibleItemFromCartParam) { [weak self] result in
            guard let self = self else { return }
            self.responseHandeler(result)
        }
    }
}

// MARK: - Handel Response

extension CartViewModel {
    private func responseHandeler(_ result: Result<CartDataModel, ResultError>) {
        switch result {
        case .success(let model):
            self.model.value = model
            guard let completion = self.onRequestCompletion else { return }
            completion(model.message)
        case .failure(let error):
            self.requestError?.value = error
        }
    }
}

// MARK: - VM Protocol Imp

extension CartViewModel: CartVMProtocol {
    
    var numberOfItems: Int {
        return self.model.value?.products.count ?? 0
    }
    
    var userCanCheckout: Bool{
        return model.value?.canCheckout == 1
    }
    
    var notAvailableItems: [String]?{
        return (model.value?.outOfStock ?? []).map{$0}
    }
    
    func optionsIsEmpty(at index: IndexPath) -> Bool?  {
        return self.model.value!.products[index.row].options.isEmpty
    }

    func dequeCellForRow(at index: IndexPath) -> CartProductsModel {
        return self.model.value!.products[index.row]
    }

    func updateCount(_ count: Int, productsId: Int, options: String) {
        self.params.count = count.toString
        self.params.productID = productsId.toString
        self.params.options = options
        self.showIndicator.value = true
        self.repo?.addToCart(self.params) { [weak self] result in
            guard let self = self else { return }
            self.showIndicator.value = false
            switch result {
            case .success(let model):
                print(model)
                self.viewDidLoad()
            case .failure(let error):
                self.requestError?.value = error
            }
        }
    }

    func continuetoCheckout() {
        if CachingManager.shared.isLogin {
            guard let model_ = model.value else{return}
            if CachingManager.shared.loginSocialWithEmptyPhone() {
                self.coordinator?.present(MainDestination.EditProfileWithPhone(model_))
            } else {
                coordinator?.navigateTo(MainDestination.checkout(model_))
            }
        } else {
            self.coordinator?.present(MainDestination.cartGuestAlert(self.model.value))
        }
    }
}

// MARK: - Change Count Protocol Imp

extension CartViewModel: ChangeCountProtocol {
    func didIncreaseCount<T>(_ item: T) {
        if var item_ = item as? CartProductsModel {
            if item_.count < item_.num {
                var optionItems: [OptionItems]?
                for i in item_.options{
                    optionItems = i.product_option_items
                }
                self.updateCount(1, productsId: item_.id, options: item_.optionItems.map{ $0.id.toString }.joined(separator: ", "))

            } else {
                self.onRequestCompletion!(R.string.localizable.youHaveReachToMaximumQuantityOfThisProduct())
            }
        }
    }

    func didDecreaseCount<T>(_ item: T) {
        if var item_ = item as? CartProductsModel {
            guard item_.count > 1 else { return }
            if item_.count <= item_.num {
                var optionItems: [OptionItems]?
                for i in item_.options{
                    optionItems = i.product_option_items
                }
                self.updateCount(-1, productsId: item_.id, options: item_.optionItems.map{ $0.id.toString }.joined(separator: ", "))
            }
        }
    }
}

// MARK: - Delete Item Protocol Imp

extension CartViewModel: DeleteItemProtocol {
    func didTapDeleteButton<T>(item: T) {
        if let item_ = item as? CartProductsModel {
            let itemId = item_.cartId
            self.parameters.productID = itemId.toString
            self.repo?.deletItem(self.parameters) { [weak self] result in
                guard let self = self else { return }
                self.responseHandeler(result)
            }
        }
    }
}

struct clearUnAvailbleItemFromCartParams: Parameters {
    var body: [String: Any] {
        return ["clear_out_of_stock": 1]
    }
}

// MARK: - VM Protocol

protocol CartVMProtocol: ViewModel {
    var showIndicator: Observable<Bool> { get set }
    var numberOfItems: Int { get }
    var model: Observable<CartDataModel> { get set }
    var userCanCheckout: Bool {get}
    var itemType: CartItemType { get set }
    var notAvailableItems:[String]?{get}
    func viewDidLoad()
    func dequeCellForRow(at index: IndexPath) -> CartProductsModel
    func continuetoCheckout()
    func clearUnAvailableItemsFromCart()
    func optionsIsEmpty(at index: IndexPath) -> Bool?
}

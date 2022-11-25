//
//  ProductDetailsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import Foundation

final class ProductDetailsViewModel {
    private var repo: ProductDetailsRepoProtcol?
    private var coorinator: Coordinator?
    private var options: [ExtraOption] = []
    private var multioptions: [OptionItems] = []
    private var product: ProductDetailsModel?
    private var selectedOptions: [OptionItems] = []
    private var cartParameters: AddToCartParams!
    private var params = AddItemToBoxesParameters()
    private var boxToClear: BoxesDataModel?
    var userSelectedCount: Observable<Int> = Observable(1)
    var decreaseCount: Observable<Int> = Observable(1)
    var ID: Int = 0 {
        didSet {
            cartParameters = AddToCartParams(id: ID, count: 1)
        }
    }

    var shouldClearBox: Bool = false
    var shouldClearCart: Bool = false
    var requestError: Observable<ResultError>? = Observable(nil)
    var onRequestCompletion: ((String?) -> Void)?
    var state: State = .notStarted
    var sliderItems: [ZSliderSource] = []
    init(_ repo: ProductDetailsRepoProtcol?, _ coorinator: Coordinator?) {
        self.repo = repo
        self.coorinator = coorinator
    }
}

// MARK: - Functionality

extension ProductDetailsViewModel: ProductDetailsVMProtocol {

    var isLiked: Bool {
        get {
            return product?.liked ?? false
        }
        set {
            //
        }
    }
    
    var productName: String {
        return product?.name ?? ""
    }
    
    var productPrice: String {
        return (product?.price ?? "").addCurrency()
    }
    
    var priceBefore: String {
        return product?.priceBefore ?? ""
    }
    
    var itemCount: Int {
        return product?.num ?? 0
    }
    
    var total: String {
        return product?.price ?? ""
    }
    
    var totalPrice: String {
        let price = product?.price ?? ""
        let totalCost = Double(userSelectedCount.value ?? 0) * price.toDouble
        return String(totalCost)
    }
    
    var desctiption: String {
        return product?.content ?? ""
    }
    
//    var isLiked: Bool {
//        return product?.liked ?? false
//    }
    
    var numberOfOptions: Int {
        return options.count
    }

    func onViewDidLoad() {
        repo?.getProduct(with: ID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.state = .success
                self.sliderItems = model.images
                self.options = model.options
                for i in self.options{
                    self.multioptions = i.product_option_items
                }
                self.product = model
                guard let completion = self.onRequestCompletion else { return }
                completion("")
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }
    
    func optionForCell(at index: Int) -> ExtraOption {
        return options[index]
    }
    
    func optionForMutliCell(at index: Int) -> OptionItems{
        return multioptions[index]
    }
    
    func didSelectOption(at index: Int) {
        selectedOptions.append(multioptions[index])
        print("sleeeeee---",selectedOptions)
    }
    
    func detectOptionPrice(at index: Int) -> Double {
        return multioptions[index].price ?? 0.0
    }
    
    func didDeSelectOption(at index: Int) {
        let deSelectedOptionID = multioptions[index].id
        selectedOptions.removeAll(where: { $0.id == deSelectedOptionID })
    }

    func addToCart() {
            //cartParameters.options = options.map { $0.id.toString }.joined(separator: ",")
            cartParameters.optionItmes = selectedOptions.map { $0.id.toString }.joined(separator: ",")
            repo?.addToCart(cartParameters) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    guard let completion = self.onRequestCompletion else { return }
                    self.shouldClearCart = !model.status
                    completion(model.message)
                    
                case .failure(let error):
                    self.requestError?.value = error
                }
            }        
    }
    
    func addToBoxes() {
        coorinator?.present(MainDestination.addToBoxesDialog { [weak self] selectedBoxes in
            guard let self = self else { return }
            let boxes = selectedBoxes.map { $0.id.toString }.joined(separator: ",")
            self.addItemTo(boxes)
        })
    }
    
    private func addItemTo(_ boxes: String) {
        params.productID = ID.toString
        params.count = userSelectedCount.value?.toString ?? ""
        params.boxes = boxes
        params.options = selectedOptions.map { $0.id.toString }.joined(separator: ",")
        repo?.addItemToBoxes(params) { [weak self] result in
  
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let completion = self.onRequestCompletion else { return }
                self.shouldClearBox = !model.status
                self.boxToClear = model.boxToClear
                completion(model.message)
            case .failure(let error):
                self.requestError?.value = error
            }
        }
    }

    func increaseQuantity() {
        let maximum = product?.num ?? 0
        guard userSelectedCount.value! < maximum else {
            guard let completion = onRequestCompletion else { return }
            completion(R.string.localizable.youHaveReachToMaximumQuantityOfThisProduct())

            return
        }
        userSelectedCount.value! += 1
        cartParameters.count = userSelectedCount.value ?? 1
    }

    func decreaseQuantity() {
        guard userSelectedCount.value! > 1 else { return }
        userSelectedCount.value! -= 1
        cartParameters.count = userSelectedCount.value ?? 1
    }
    
    func likeDisLike() {
        repo?.likeDisLike(ID, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.state = .success
                self.product?.liked = model.isLiked
                //self.onViewDidLoad()
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
    
    func goToNotifications() {
        coorinator?.navigateTo(MainDestination.notifications)
    }
    
    func clearBox() {
        guard let box_ = boxToClear else { return }
        repo?.clearBox(with: box_.id) { [weak self] _ in
            guard let self = self else { return }
            self.shouldClearBox = false
            let boxes = self.params.boxes ?? ""
            self.addItemTo(boxes)
            guard let completion = self.onRequestCompletion else { return }
            completion("")
        }
    }
    
    func clearCart() {
        repo?.clearCart { [weak self] _ in
            self?.shouldClearCart = false
            self?.addToCart()
        }
    }
}

protocol ProductDetailsVMProtocol: ViewModel {
    var userSelectedCount: Observable<Int> { get set }
    var decreaseCount: Observable<Int> { get set }
    var sliderItems: [ZSliderSource] { get set }
    var numberOfOptions: Int { get }
    var productName: String { get }
    var productPrice: String { get }
    var priceBefore: String { get }
    var totalPrice: String { get }
    var total: String { get }
    var desctiption: String { get }
    var itemCount: Int { get }
    var isLiked: Bool { get set }
    var shouldClearBox: Bool { get set }
    var shouldClearCart: Bool { get set }
    func onViewDidLoad()
    func detectOptionPrice(at index: Int) -> Double
    func increaseQuantity()
    func decreaseQuantity()
    func optionForCell(at index: Int) -> ExtraOption
    func optionForMutliCell(at index: Int) -> OptionItems
    func didSelectOption(at index: Int)
    func didDeSelectOption(at index: Int)
    func addToCart()
    func addToBoxes()
    func likeDisLike()
    func goToNotifications()
    func clearBox()
    func clearCart()
}

struct AddItemToBoxesParameters: Parameters {
    var productID: String = ""
    var count: String = ""
    var boxes: String = ""
    var options:String = ""
    
    var body: [String: Any] {
        return ["product_id": productID,
                "count": count,
                "boxes": boxes,
                "option_items": options,]
    }
}

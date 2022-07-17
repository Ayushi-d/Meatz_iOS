//
//  ShopDetailsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation

final class ShopDetailsViewModel {
    var requestError: Observable<ResultError>? = Observable(nil)
    var state: State = .notStarted
    var onRequestCompletion: ((_ message : String?) -> Void)? 
    var shopID: Int!
    var activityIndicator: Observable<Bool> = Observable.init(false)
    private var repo: ShopDetailsRepoProtocol?
    private var coordinator: Coordinator?
    private var parameters: ShopDetailsParams!
    private var products : [Listable] = []
    private var ads : [AdModel] = []
    var filterCategories: [CategoryModel] = []
    
    
    var model: Observable<ShopDetailsModel> = Observable(nil)
    init(_ repo: ShopDetailsRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
        parameters = ShopDetailsParams()
    }
}

extension ShopDetailsViewModel: ShopDetailsVMProtocol {
    var numberOfProducts: Int {
        return products.count
    }
    
    var numberofSubcategories: Int{
        return 3
    }
    
    func onViewDidLoad() {
        activityIndicator.value = true
        guard shopID != nil else { return }
        repo?.getShopDetails(shopID, params: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.model.value = model
                self.products = model.products
                self.state = .success
                self.ads = model.ads
                self.populateItemsWithAds()
                
                self.filterCategories = model.categories
                
                
                
                self.activityIndicator.value = false
                guard let completion = self.onRequestCompletion else{return}
                completion(nil)
            case .failure(let error):
                self.requestError?.value = error
                self.state = .finishWithError(error)
                self.activityIndicator.value = false
            }
        }
    }

    fileprivate func populateItemsWithAds(){
        var j : Int = 0
        for i in 0..<products.count{
            if (i+1) % 6 == 0 {
                products.insert(ads[j], at: j+i+1)
                j += 1
            }
        }
    }
    
    func viewModelForCell(at index: Int) -> Listable {
        return products[index]
    }

    func filter() {
        self.coordinator?.present(MainDestination.filterView(options: filterCategories, parameters.categories) { [weak self] option in
            guard let self = self else { return }
            self.parameters.categories = option
            self.onViewDidLoad() /// resend the request with updated parameters
        })
    }

    func didselectSliderItem(at index: Int) {
        var destination : MainDestination!
        let sliderIndex = index - 6
        let item = ads[sliderIndex]
        let type = item.modelType
        switch type{
        case .box:
            destination = .box(item.modelID)
        case .product:
            destination = .product(item.modelID)
        case .store:
            guard (model.value?.id ?? 0) != item.modelID else{return}
            destination = .shopDetails(item.modelID)
        default:
            return
        }
        coordinator?.navigateTo(destination)
    }
    
    func didSelectProduct(at index: Int) {
        let id = products[index].itemID
        let type = products[index].type
        if type == .specialOffer {
            coordinator?.navigateTo(MainDestination.offerDetails(id))
        } else {
            coordinator?.navigateTo(MainDestination.product(id))
        }
        
    }
    func sort() {
        self.coordinator?.present(MainDestination.sort(parameters.option) { [weak self] option in
            guard let self = self else { return }
            self.parameters.option = option
            self.onViewDidLoad()
        })
    }
}

// MARK: - ViewModel Protocol

protocol ShopDetailsVMProtocol: ViewModel {
    var numberOfProducts: Int { get }
    var numberofSubcategories : Int { get }
    var model: Observable<ShopDetailsModel> { get set }
    var activityIndicator : Observable<Bool>{get set}
    func onViewDidLoad()
    func didselectSliderItem(at index: Int)
    func didSelectProduct(at index : Int)
    func viewModelForCell(at index: Int) -> Listable
    func filter()
    func sort()
}

// MARK: - Parameters

struct ShopDetailsParams: Parameters {
    var option: SortOption?
    
    var categories: [CategoryModel] = []
    var body: [String: Any] {
        return ["filter_by": option?.rawValue ?? "",
                "category_id": categories.map({return $0.id.toString}).joined(separator: ",")]
    }
}

// MARK: - Filter options

enum SortOption : String{
    case high_price
    case low_price
    case latest

    var title: String {
        switch self {
        case .high_price:
            return R.string.localizable.priceHighToLow()
        case .low_price:
            return R.string.localizable.priceLowToHigh()
        case .latest:
            return R.string.localizable.newest()
        }
    }
}

enum FilterOption: Int {
    case meat = 1
    case poultry = 2
    case fish = 3

    var title: String {
        switch self {
        case .fish:
            return R.string.localizable.fish()
        case .meat:
            return R.string.localizable.meat()
        case .poultry:
            return R.string.localizable.poultry()
        }
    }
}

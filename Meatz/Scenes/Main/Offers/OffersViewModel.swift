//
//  OffersViewModel.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/19/21.
//

import Foundation

enum OffersParameterType {
    case id(Int)
    case key(String)
}


class OffersViewModel {
    
    private var categories: [CategoryModel] = []
    private var offers: [BoxModel] = []
    private var numberOfResults: Int = 0
    
    var showActivityIndicator: Observable<Bool> = Observable(false)
    var state: State = .notStarted
    var onRequestCompletion: ((_ message : String?) -> Void)? //
    var requestError: Observable<ResultError>? = Observable(.none)
    var selectedId: Int = 0
    
    private var repo: OffersRepoProtocol
    private var coordinator: Coordinator?
    
    private var offersParameter = OffersParameter()
    
    init(repo: OffersRepoProtocol, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }

}

extension OffersViewModel: OffersVMProtcol {
    var numberOfCategories: Int {
        return categories.count
    }
    
    var numberOfOffers: Int {
        return offers.count
    }
    
    var isSearched: Bool {
        offersParameter.searchKeyword.isEmpty
    }
    
    func getCategoryModel(at indexPath: IndexPath) -> CategoryModel {
        return categories[indexPath.item]
    }
    
    func getOfferModel(at indexPath: IndexPath) -> BoxModel {
        return offers[indexPath.row]
    }
    
    func viewOnDidLoad() {
        repo.getOffersData(parameter: offersParameter) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.populateWith(model)
                guard let completion = self.onRequestCompletion else{return}
                completion(nil)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }
    
    fileprivate func populateWith(_ model: OffersModel) {
        state = .success
        if selectedId != 0 {
            categories = model.categories
            if let i = categories.firstIndex(where: {$0.id == selectedId}) {
                categories[i].selected = true
            }
        } else {
            categories = model.categories
        }
        offers = model.boxs
        numberOfResults = offers.count
    }
    
    func didSelectBox(at index: Int) {
        // navigate to details
    }
    
    func didSelectCategory(at index: Int) {
        selectedId = categories[index].id
        showActivityIndicator.value = true
        updateParameters(type: .id(categories[index].id))
        viewOnDidLoad()
    }
    
    func updateParameters(type: OffersParameterType) {
        switch type {
        case .id(let id):
            offersParameter.categoryId = id
        case .key(let key):
            offersParameter.searchKeyword = key
        }
    }
    
    func didselectOfferItem(at index: Int) {
        coordinator?.navigateTo(MainDestination.offerDetails(offers[index].id))
    }
    
    func goToNotification() {
        coordinator?.navigateTo(MainDestination.notifications)
    }
    
    func handelSearchKey(text: String) {
        offersParameter.searchKeyword = text
    }
    
    func search() {
        viewOnDidLoad()
    }
}

protocol OffersVMProtcol: ViewModel, OffersCountable, OffersModelsData, OffersSelectable {
    var showActivityIndicator: Observable<Bool> { get set }
    func viewOnDidLoad()
    func updateParameters(type: OffersParameterType)
    func goToNotification()
    func handelSearchKey(text: String)
    func search()
}


protocol OffersCountable {
    var numberOfCategories: Int { get }
    var numberOfOffers: Int { get }
    var isSearched: Bool { get }
}

protocol OffersSelectable{
//    func didSelectShop(at index : Int)
    func didSelectBox(at index : Int)
    func didSelectCategory(at index : Int)
    func didselectOfferItem(at index : Int)
//    func goToNotification()
}


protocol OffersModelsData {
    func getCategoryModel(at indexPath: IndexPath) -> CategoryModel
    func getOfferModel(at indexPath: IndexPath) -> BoxModel
}

struct OffersParameter: Parameters {
    var categoryId: Int = 0
    var searchKeyword: String = ""
    
    var body: [String : Any] {
        return ["category_id": categoryId,
                "keyword": searchKeyword]
    }
}

//
//  SearchViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/4/21.
//

import Foundation

final class SearchViewModel {
    private var repo: SearchRepoProtocol?
    private var coordinator: Coordinator?
    private var stores: [StoreModel] = []
    private var items: [ProductViewModel] = []
    private var model : SearchModel?
    var onRequestCompletion: ((_ message : String?) -> Void)? 
    var requestError: Observable<ResultError>? = Observable(nil)
    var state: State = .notStarted
    init(_ repo: SearchRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension SearchViewModel: SearchVMProtocol {
    var numberOfStores: Int {
        return stores.count
    }

    var numberOfItems: Int {
        return items.count 
    }
    var isStoresEmpty: Bool{
        return stores.isEmpty
    }
    
    var isItemsEmpty: Bool{
        return items.isEmpty
    }
    func search(key: String) {
        let parameters = SearchParams(keyword: key)
        repo?.getSearch(parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.model = model
                self.state = .success
                self.stores = model.stores
                self.items = model.products
                guard let completion = self.onRequestCompletion else{return}
                completion(nil)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }

    func viewModelForStore(at index: Int) -> Listable {
        return stores[index]
    }

    func viewModelForeItem(at index: Int) -> Listable {
        return items[index]
    }

    func titleForSection(_ section: Int) -> String {
        if section == 0 {
            return R.string.localizable.theShops()
        }
        return R.string.localizable.theItems()
    }
    
    func seeMoreItems() {
        guard let searchModel = model else{return}
        coordinator?.navigateTo(MainDestination.searchResult(.items, searchModel))
    }
    
    func seeMoreStores() {
        guard let searchModel = model else{return}
        coordinator?.navigateTo(MainDestination.searchResult(.shops, searchModel))
    }
    
    func didSelectItem(at index: Int) {
        guard let id = model?.products[index].id else{return}
        let type = model?.products[index].type
        
        if type == .specialOffer {
            coordinator?.navigateTo(MainDestination.offerDetails(id))
        } else {
            coordinator?.navigateTo(MainDestination.product(id))
        }
    }
    func didSelectStore(at index: Int) {
        let id = stores[index].id
        coordinator?.navigateTo(MainDestination.shopDetails(id))
    }
}

protocol SearchVMProtocol: ViewModel,SearchFunctional {
    var numberOfStores: Int { get }
    var numberOfItems: Int { get }
    var isStoresEmpty : Bool{get}
    var isItemsEmpty : Bool {get}
    
}

protocol SearchFunctional {
    func search(key: String)
    func viewModelForStore(at index: Int) -> Listable
    func viewModelForeItem(at index: Int) -> Listable
    func titleForSection(_ section: Int) -> String
    func seeMoreStores()
    func seeMoreItems()
    func didSelectItem(at index : Int)
    func didSelectStore(at index : Int)
}

struct SearchParams: Parameters {
    var keyword: String = ""
    var more: Int = 1

    var body: [String: Any] {
        return ["keyword": keyword, "more": more]
    }
}

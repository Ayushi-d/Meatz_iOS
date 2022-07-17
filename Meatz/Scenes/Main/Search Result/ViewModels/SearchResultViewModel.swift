//
//  SearchResultViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/5/21.
//

import Foundation

final class SearchResultViewModel{
    private var model : SearchModel
    private var coordinator : Coordinator?
    var currentSelectedTab: SearchTab = .shops
    init(_ model : SearchModel,_ coordinator : Coordinator?) {
        self.model = model
        self.coordinator = coordinator
    }
}

extension SearchResultViewModel : SearchResultVMProtocol{
    var numberOfProducts: Int {
        return model.products.count
    }
    
    var numberOfStores: Int {
        return model.stores.count
    }
    
    var itemsCount: String{
        let itemsString = R.string.localizable.items().lowercased()
        let shopsString = R.string.localizable.shop().lowercased()
        return currentSelectedTab == .items ? numberOfProducts.toString + " " + itemsString : numberOfStores.toString + " " + shopsString
    }
    func viewModelForStore(at index: Int) -> Listable {
        return model.stores[index]
    }
    
    func viewModelForeItem(at index: Int) -> Listable {
        return model.products[index]
    }
    
    func didSelectItem(at index: Int) {
        let id = model.products[index].id
        let type = model.products[index].type
        if type == .specialOffer {
            coordinator?.navigateTo(MainDestination.offerDetails(id))
        } else {
            coordinator?.navigateTo(MainDestination.product(id))
        }
    }
    
    func didSelectStore(at index: Int) {
        let id = model.stores[index].id
        coordinator?.navigateTo(MainDestination.shopDetails(id))
    }
    
    
}

protocol SearchResultVMProtocol{
    var currentSelectedTab : SearchTab {get set}
    var numberOfProducts : Int{get}
    var numberOfStores : Int{get}
    var itemsCount : String{get}
    func viewModelForStore(at index: Int) -> Listable
    func viewModelForeItem(at index: Int) -> Listable
    func didSelectItem(at index : Int)
    func didSelectStore(at index : Int)
}

enum SearchTab : Equatable{
    case items
    case shops
}

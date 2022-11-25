//
//  ShopsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/28/21.
//

import Foundation

final class ShopsViewModel {
    typealias ResponseType = StoresResponse
    var state: State = .notStarted
    var onRequestCompletion: ((_ message : String?) -> Void)? 
    private var repo: ShopsRepoProtocol?
    private var coordinator: Coordinator?
    private var shops: [StoreModel] = []
    private var selectedCategoryID : Int = 1
    var requestError: Observable<ResultError>? = Observable.init(nil)
    
    var categories: Observable<[CategoryModel]> = Observable([])
    
    init(_ repo: ShopsRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension ShopsViewModel: ShopsViewModelProtocol {
  
    var numberOfShops: Int {
        return shops.count
    }

    func onViewDidLoad() {
        repo?.getShops(selectedCategoryID,{ [weak self] (response, error) in
            guard let self = self else { return }
            if let error_ = error{
                self.requestError?.value = error_
            }else{
                self.shops = response?.shops ?? []
                self.state = .success
                guard let completion = self.onRequestCompletion else{return}
                completion(nil)
            }
            
        })
    }

    func categoryForItem(at index: Int) -> CategoryModel {
        return categories.value?[index] ?? CategoryModel(model: nil)
    }

    func shopForItem(at index: Int) -> Listable {
        return shops[index]
    }

    func selectCategory(at index: Int) {
        for i in 0..<(categories.value?.count ?? 0) {
            categories.value?[i].selected = false
        }
        categories.value?[index].selected = true
        selectedCategoryID = categories.value?[index].id ?? 0
        onViewDidLoad()
    }
    
    func selectShop(at index: Int) {
        let id = shops[index].id
        coordinator?.navigateTo(MainDestination.shopDetails(id))
    }
    
    func goToNotification() {
        coordinator?.navigateTo(MainDestination.notifications)
    }
}

protocol ShopsViewModelProtocol: ViewModel {
    var numberOfShops: Int { get }
    func onViewDidLoad()
    func categoryForItem(at index: Int) -> CategoryModel
    func shopForItem(at index: Int) -> Listable
    func selectCategory(at index: Int)
    func selectShop(at index :Int)
    func goToNotification()
    var categories: Observable<[CategoryModel]> { get set }
}


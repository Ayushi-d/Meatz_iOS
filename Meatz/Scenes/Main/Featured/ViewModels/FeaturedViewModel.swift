//
//  FeaturedViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/30/21.
//

import Foundation

final class FeaturedViewModel {
    private var repo : FeaturedRepoProtocol?
    private var coordinator : Coordinator?
    var onRequestCompletion: ((_ message : String?) -> Void)? 
    var requestError: Observable<ResultError>?
    var state: State = .notStarted
    private var shops : [Listable] = []
    init(_ repo : FeaturedRepoProtocol?,_ coordinator : Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}
extension FeaturedViewModel : FeaturedVMProtocol{
    var numberOfShops: Int{
        return shops.count
    }
    func onViewDidLoad() {
        repo?.getFeaturedStores({ [weak self](result) in
            guard let self = self else{return}
            switch result{
            case .success(let model):
                self.shops = model.stores
                self.state = .success
                guard let completion = self.onRequestCompletion else{return}
                completion(nil)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
    func viewModelForShop(at index: Int) -> Listable {
        return shops[index]
    }
    
    func didSelectShop(at index: Int) {
        let id = shops[index].itemID
        coordinator?.navigateTo(MainDestination.shopDetails(id))
    }
    
}
protocol FeaturedVMProtocol : ViewModel{
    var numberOfShops : Int{get}
    func onViewDidLoad()
    func viewModelForShop(at index : Int) -> Listable
    func didSelectShop(at index : Int)
}

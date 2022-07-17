//
//  WhishlistViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/12/21.
//

import Foundation

final class WhishlistViewModel {
    private var repo : WhishlistRepoProtocol?
    private var coordinator : Coordinator?
    private var items : [WishlistItemModel] = []
    private var currentPage : Int = 1
    private var nextPage : Bool = true
    var state: State = .notStarted
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable.init(nil)
    init(_ repo : WhishlistRepoProtocol?,_ coordinator : Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
    
}

//MARK:- Functionality
extension WhishlistViewModel : WhishlistVMProtocol{
    var numberOfItems: Int{
        return items.count
    }
    func onViewDidLoad() {
        guard nextPage else{return}
        repo?.getWhishList(currentPage, { [weak self](result) in
            guard let self = self else{return}
            switch result{
            case .success(let model):
                self.state = .success
                self.items.append(contentsOf: model.items)
                self.nextPage = model.isThereNextPage
                self.currentPage = model.currentPage
                guard let completion = self.onRequestCompletion else{return}
                completion("")
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
    
    func viewModelForItem(at index: Int) -> Listable {
        return items[index]
    }
    
    func didSelectItem(at index: Int) {
        let item = items[index]
        switch item.navigationType{
        case .box:
            coordinator?.navigateTo(MainDestination.box(item.id))
        case .product:
            coordinator?.navigateTo(MainDestination.product(item.id))
        case .store:
            coordinator?.navigateTo(MainDestination.shopDetails(item.id))
        default:break
        }
    }
    
    func disLike(_ id: Int) {
        repo?.likeDisLike(id, completion: {[weak self] (result) in
            guard let self = self else{return}
            switch result{
            case .success(_):
                self.state = .success
                self.items = self.items.filter({return $0.id != id})
                guard let completion = self.onRequestCompletion else{return}
                completion("")
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
}



protocol WhishlistVMProtocol : ViewModel{
    var numberOfItems : Int{get}
    
    func onViewDidLoad()
    func viewModelForItem(at index : Int) -> Listable
    func didSelectItem(at index : Int)
    func disLike(_ id : Int)
}

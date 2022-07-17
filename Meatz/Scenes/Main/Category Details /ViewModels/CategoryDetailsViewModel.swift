//
//  CategoryDetailsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/31/21.
//

import Foundation

final class CategoryDetailsViewModel{
    private var repo : ShopsRepoProtocol?
    private var coordinator : Coordinator?
    private var shops : [Listable] = []
    private var ads : [AdModel] = []
    private var model : StoresModel?
    var state: State = .notStarted
    var onRequestCompletion: ((_ message : String?) -> Void)? 
    var requestError: Observable<ResultError>? = Observable.init(nil)
    var category : CategoryModel?
    
    init(_ repo : ShopsRepoProtocol?,_ coordinator : Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

//MARK:- Functionality
import UIKit
extension CategoryDetailsViewModel : CategoryDetailsVMProtocol{
   
    var numberOfShops: Int{
        return shops.count
    }
    
    var isShopsEmpty: Bool{
        return shops.isEmpty
    }
    var categoryLogo: String{
        return category?.image ?? ""
    }
    var categoryName: String {
        return category?.name ?? ""
    }
    
    var shopsCountString: String {
        return shops.count.toString + " " + R.string.localizable.shopAvailable()
    }
    
    var cartCount: Int{
        return model?.cart.count ?? 0
    }
    
    var cartTotal: String{
        return String(format: "%.3f", Double((model?.cart.total ?? 0))).addCurrency()
    }
    var isCartEmpty: Bool{
        return (model?.cart.count ?? 0) == 0
    }
    func onViewDidLoad() {
        guard let id = category?.id else{return}
        repo?.getShops(id, { [weak self ](model, error) in
            guard let self = self else{return}
            if let err = error {
                self.requestError?.value = err
            }else{
                self.model = model
                self.shops = model?.shops ?? []
                self.ads = model?.ads ?? []
                self.populateWithAds()
                guard let completion = self.onRequestCompletion else{return}
                completion(nil)
            }
        })
    }
    /// populates shops array with ads after each two rows
    fileprivate func populateWithAds(){
        var j : Int = 0
        var shopsCopy = shops
        for i in 0..<shops.count{
            if (i+1) % 6 == 0 {
                shopsCopy.insert(ads[j], at: j+i+1)
                j += 1
            }
        }
        shops = shopsCopy
    }
    func shopForItem(at index: Int) -> Listable {
        return shops[index]
    }
    
    func selectShop(at index: Int) {
        if index % 6 == 0 && index != 0 {  /// here if click on banner we check model type to determine our navigation
            var destination : MainDestination!
            let item = shops[index] as! AdModel

            switch item.modelType{
            case .box:
                destination = .box(item.itemID)
            case .product:
                destination = .product(item.modelID)
            case .store:
                destination = .shopDetails(item.modelID)
            default:
                return
            }
            coordinator?.navigateTo(destination)
        }else{ ///  navigation to shop details
            let id = shops[index].itemID
            coordinator?.navigateTo(MainDestination.shopDetails(id))
        }
    
    }
    
    
    func viewCart() {
        coordinator?.navigateTo(MainDestination.cart)
    }
}
protocol CategoryDetailsVMProtocol : ViewModel , CategoryFunctionable{
    var category : CategoryModel?{get set}
    var numberOfShops: Int { get }
    var categoryLogo : String{get}
    var categoryName : String{get}
    var shopsCountString : String{get}
    var isShopsEmpty : Bool {get}
    var isCartEmpty : Bool{get}
    var cartCount : Int{get}
    var cartTotal : String{get}
}

protocol CategoryFunctionable{
    func onViewDidLoad()
    func shopForItem(at index: Int) -> Listable
    func selectShop(at index :Int)
    func viewCart()
}


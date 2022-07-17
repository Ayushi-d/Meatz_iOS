//
//  WishlistModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/12/21.
//

import Foundation


// MARK: - WishlistResponse
struct WishlistResponse: Codable {
    let status, message: String?
    let data: [WishlistItem]?
    let pagination: Pagination?
}

// MARK: - WishlistData
struct WishlistItem: Codable {
    let id: Int?
    let type : SliderType
    let name, price: String?
    let priceBefore: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, type, name, price
        case priceBefore = "price_before"
        case image
    }
}


// MARK: - Pagination
struct Pagination: Codable {
    let total, lastPage, perPage, currentPage: Int?
}


struct WishlistModel{
    let items : [WishlistItemModel]
    var isThereNextPage : Bool
    var currentPage : Int
    let lastPage : Int
    init(_ res : WishlistResponse?) {
        items = (res?.data ?? []).map({return WishlistItemModel($0)})
        lastPage = res?.pagination?.lastPage ?? 1
        currentPage = res?.pagination?.currentPage ?? 1
        isThereNextPage = currentPage < lastPage
    }
}

struct WishlistItemModel : Listable{
    
    let id: Int
    let navigationType : SliderType
    let name, price: String
    let priceBefore: String
    let image: String

    init(_ item : WishlistItem?) {
        id = item?.id ?? 0
        navigationType = item?.type ?? .none
        name = item?.name ?? ""
        price = item?.price ?? ""
        priceBefore = item?.priceBefore ?? ""
        image = item?.image ?? ""
    }
    
    var itemID : Int{
        return id
    }
    var itemName : String {
        return name
    }
    var imageLink : String{
        return image
    }
    
    var cost : String{
        return price.addCurrency()
    }
    var costBefore: String{
        return priceBefore
    }
    
    var adType: AdType{
        return .product
    }
    
    var itemType: ItemType{
        return .product
    }
}

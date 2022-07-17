//
//  ShopDetailsModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation


// MARK: - HomeResponse
struct ShopDetailsResponse: Codable {
    let status, message: String?
    let data: ShopDetailsData?
}

// MARK: - DataClass
struct ShopDetailsData: Codable {
    let store: StoreDetails?
    let cart: Cart?
    let ads: [Ad]?
    let categories: [Category]?
}


// MARK: - Cart
struct Cart: Codable {
    let count: Int?
    let total: Double?
}

// MARK: - Store
struct StoreDetails: Codable {
    let id: Int?
    let name: String?
    let logo: String?
    let color: String?
    let productsCount: Int?
    let products: [Product]?

    enum CodingKeys: String, CodingKey {
        case id, name, logo, color
        case productsCount = "products_count"
        case products
    }
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let name, price: String?
    let priceBefore: String?
    let image: String?
    let type : SearchItemType?
    enum CodingKeys: String, CodingKey {
        case id, name, price
        case priceBefore = "price_before"
        case image
        case type
    }
}

enum SearchItemType : String ,Codable{
    case box
    case product
    case specialBox = "special_box"
}
struct ShopDetailsModel{
    
    let id: Int
    let name: String
    let logo: String
    let color: String
    let productsCount: String
    let products: [ProductViewModel]
    let ads : [AdModel]
    let cart : CartModel
    let categories: [CategoryModel]
    
    init(_ res : ShopDetailsResponse?) {
        id = res?.data?.store?.id ?? 0
        name = res?.data?.store?.name ?? ""
        logo = res?.data?.store?.logo ?? ""
        color = res?.data?.store?.color ?? ""
        productsCount = (res?.data?.store?.productsCount ?? 0).toString + " " + R.string.localizable.items()
        products = (res?.data?.store?.products ?? []).map({return ProductViewModel($0)})
        ads = (res?.data?.ads ?? []).map({return AdModel($0)})
        cart = CartModel(res?.data?.cart)
        
        categories = res?.data?.categories?.map({CategoryModel(model: $0)}) ?? []
    }
    
    
}

struct CartModel{
    let count: Int
    let total: Double
    init(_ cart : Cart?) {
        count = cart?.count ?? 0
        total = cart?.total ?? 0
    }
}

struct ProductViewModel : Listable{
    let id: Int
    let name, price: String
    let priceBefore: String
    let image: String
    let productType: SearchItemType

    init(_ product : Product? ) {
        id = product?.id ?? 0
        name = product?.name ?? ""
        price = (product?.price ?? "") + " " + R.string.localizable.kwd()
        priceBefore = (product?.priceBefore ?? "")
        image = product?.image ?? ""
        productType = product?.type ?? .product
    }
    
    var itemID: Int{
        return id
    }
    var cost : String{
        return price
    }
    var costBefore : String{
        return priceBefore
    }
    var itemName: String{
        return name
    }
    
    var imageLink: String{
        return image
    }
    
    var type : ItemType {
        if productType == .specialBox {
            return .specialOffer
        } else {
            return .product
        }
        
    }
    
}

struct AdModel : Listable{
    let id, status, sort: Int
    let title: String
    let modelType : AdType
    let modelID: Int
    let image: String

    init(_ ad : Ad?) {
        id = ad?.id ?? 0
        status = ad?.status ?? 0
        sort = ad?.sort ?? 0
        title = ad?.title ?? ""
        modelType = AdType.init(rawValue:(ad?.model ?? "")) ?? .none
        modelID = ad?.modelID ?? 0
        image = ad?.image ?? ""
    }
    
    var itemID : Int{
        return id
    }

    var itemName: String{
        return ""
    }
    
    var imageLink: String{
        return image
    }
    
    var type : ItemType{
        return .sliderItem
    }
    
    var navigationType : AdType{
        return modelType
    }

}

enum AdType : String{
    case none = ""
    case box
    case product
    case store
}

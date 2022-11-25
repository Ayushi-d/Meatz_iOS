//
//  ShopsModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/28/21.
//

import Foundation
// MARK: - StoresResponse
struct StoresResponse: Codable {
    let status, message: String?
    let data: StoresData?
}


// MARK: - DataClass
struct StoresData: Codable {
    let stores: [Store]?
    let ads: [Ad]?
    let cart : Cart?
}

// MARK: - Ad
struct Ad: Codable {
    let id, status, sort: Int?
    let title, model: String?
    let modelID: Int?
    let image: String?
    let banner: String?

    enum CodingKeys: String, CodingKey {
        case id, status, sort, title, model
        case modelID = "model_id"
        case image
        case banner
    }
}

// MARK: - Store
struct Store: Codable {
    let id: Int?
    let name: String?
    let logo: String?
    let color: String?
    let mobile : String?
    let banner: String?
    let rating: String?
    let tags: [TagModel]?
}


struct StoresModel{
    let shops : [StoreModel]
    let ads : [AdModel]
    let cart : CartModel
    init(_ res : StoresResponse?) {
        self.shops = (res?.data?.stores ?? []).map({return StoreModel($0)})
        self.ads = (res?.data?.ads ?? []).map({return AdModel($0)})
        self.cart = CartModel(res?.data?.cart)
    }
    /// This intiailizer is just for passing stubs for unit testing 
    init(_ shops : [StoreModel],_ ads : [AdModel]) {
        self.shops = shops
        self.ads = ads
        self.cart = CartModel(nil)
    }
    
}

struct TagModel: Codable{
    let id: Int
    let name: String
}

struct StoreModel : Listable{
    let image : String
    let name : String
    let id : Int
    let mobile : String
    let banner: String
    let rating: String
    let tags : [TagModel]
    
    init(_ shop : Store?) {
        image = shop?.logo ?? ""
        name = shop?.name ?? ""
        id = shop?.id ?? 0
        mobile = shop?.mobile ?? ""
        banner = shop?.banner ?? ""
        rating = shop?.rating ?? "0.0"
        tags = shop?.tags ?? []
    }
    
    init(id : Int ,image : String , name : String,mobile : String, banner: String, rating: String, tags : [TagModel]) {
        self.image = image
        self.name = name
        self.id = id
        self.mobile = mobile
        self.banner = banner
        self.rating = rating
        self.tags = tags
    }
    
    var itemID : Int{
        return id 
    }
    var imageLink: String{
        return image
    }
    
    var itemName: String{
        return name
    }
    var type: ItemType{
        return .product
    }
    
    var bannerLink: String{
        return banner
    }
    
    var ratingLabel: String{
        return rating
    }
}

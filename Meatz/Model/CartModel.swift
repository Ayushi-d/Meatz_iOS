//
//  CartModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//

import Foundation

// MARK: - CartResponse
struct CartResponse: Codable {
    let status: String?
    let message: String?
    let data: CartData?
}

// MARK: - DataClass
struct CartData: Codable {
    let products: [CartProduct]?
    let store: Store?
    let subtotal, delivery, total: String?
    let canCheckout: Int?
    let outOfStock: [String]?
    
    enum CodingKeys: String, CodingKey {
        case products, store, subtotal, delivery, total
        case canCheckout = "can_checkout"
        case outOfStock = "out_of_stock"
    }
}

// MARK: - Product
struct CartProduct: Codable {
    let id,cartId: Int?
    let type, name, price: String?
    let num: Int
    let persons: Int?
    let count: Int
    let store: Store?
    let options: [ProductOption]?
    let optionItems:[OptionItems]?
    let optionsTxt: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, type, name, price, num, persons, count, options
        case optionsTxt = "options_txt"
        case optionItems = "option_items"
        case image, store
        case cartId = "cart_id"
    }
}

struct CartDataModel{
    let status : Bool
    var total : String?
    var delivery : String?
    let subtotal, message: String?
    let canCheckout: Int?
    let outOfStock: [String]?
    let products: [CartProductsModel]
    let store: StoreModel?
    
    init(_ model: CartResponse?) {
        message = model?.message ?? ""
        status = (model?.status ?? "") == "success"
        subtotal = model?.data?.subtotal ?? ""
        delivery = model?.data?.delivery ?? ""
        total = model?.data?.total ?? ""
        products = (model?.data?.products ?? []).map{CartProductsModel($0)}
        store = StoreModel(model?.data?.store)
        canCheckout = model?.data?.canCheckout ?? 0
        outOfStock = model?.data?.outOfStock
        
    }
}

struct CartProductsModel{
    let id, cartId: Int
    let type: CartItemType
    let name, price: String
    let num: Int
    let persons: Int
    var count: Int
    let options: [ExtraOption]
    var optionItems: [OptionItems]
    let optionsTxt: String
    let image: String
    let store: StoreModel
    
    init(_ model: CartProduct) {
        cartId = model.cartId ?? 0
        id = model.id ?? 0
        type = CartItemType(rawValue: model.type ?? "")!
        name = model.name ?? ""
        price = model.price ?? ""
        num = model.num
        persons = model.persons ?? 0
        count = model.count 
        options = (model.options ?? []).map{ExtraOption($0)}
        optionsTxt = model.optionsTxt ?? ""
        image = model.image ?? ""
        store = StoreModel(model.store)
        optionItems = model.optionItems!
    }
}


enum CartItemType: String {
    case product
    case box
    case specialBox = "special_box"
}

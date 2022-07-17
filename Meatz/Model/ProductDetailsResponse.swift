//
//  ProductDetailsResponse.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import Foundation


// MARK: - ProductDetailsResponse
struct ProductDetailsResponse: Codable {
    let status, message: String?
    let data: ProductDetailsData?
}

// MARK: - DataClass
struct ProductDetailsData: Codable {
    let id, isActive: Int?
    let type, name, content, price: String?
    let priceBefore : String?
    let liked, persons: Int?
    let num: Int?
    let images: [Image]?
    let options: [ProductOption]?

    enum CodingKeys: String, CodingKey {
        case id
        case isActive = "is_active"
        case type, name, content, price
        case priceBefore = "price_before"
        case liked, persons, num, images, options
    }
}



// MARK: - Option
struct ProductOption: Codable {
    let id: Int?
    let name, price: String?
    let product_option_items: [OptionItems]?
}


struct ProductDetailsModel{
    
    let id : Int
    let isActive: Bool
    let type, name, content, price: String
    let priceBefore : String
    var liked : Bool
    let persons: Int
    let num: Int
    let images: [SliderInput]
    let options: [ExtraOption]

    
    init(_ res : ProductDetailsResponse?) {
        let info = res?.data
        id = info?.id ?? 0
        isActive = (info?.isActive ?? 0) == 1
        type = info?.type ?? ""
        name = info?.name ?? ""
        content = info?.content ?? ""
        price = info?.price ?? ""
        priceBefore = info?.priceBefore ?? ""
        liked = (info?.liked ?? 0) == 1
        persons = info?.persons ?? 0
        num = info?.num ?? 0
        images = (info?.images ?? []).map({return SliderInput(link: $0.image ?? "")})
        options = (info?.options ?? []).map({return ExtraOption($0)})
    }
}

struct ExtraOption{
    let id: Int
    let name, price: String
    let product_option_items : [OptionItems]
    init(_ option : ProductOption?) {
        id = option?.id ?? 0
        name = option?.name ?? ""
        price = option?.price ?? ""
        product_option_items = option?.product_option_items ?? []
    }
    
    var jsonItem : [String : Any]{
        return ["id":id,
                "name":name,
                "price":price,
                "product_option_items":product_option_items]
    }
}


struct OptionItems : Codable{
    let id : Int
    let name  : String
    let price : Double?
    init(_ option : OptionItems?) {
        id = option?.id ?? 0
        name = option?.name ?? ""
        price = option?.price ?? 0.0
    }
    var jsonItem : [String : Any]{
        return ["id":id,
                "name":name,
                "price":price ?? 0.0]
    }
}

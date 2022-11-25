//
//  BoxProductsModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/15/21.
//

import Foundation

// MARK: - BoxProductsResponse

struct BoxProductsResponse: Codable {
    let status, message: String
    let data: DataBox?
}

// MARK: - DataClass

struct DataBox: Codable {
    let box: BoxHeader?
    let products: [BoxProductsData]?
}

// MARK: - Box

struct BoxHeader: Codable {
    let id, userID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
    }
}

// MARK: - Product

struct BoxProductsData: Codable {
    let id, isActive: Int?
    let type, name, price: String?
    // let priceBefore: Int?
    let image: String?
    let count: Int?
    let total: String?
    let store: BoxStore?
    let options: [Option]?

    enum CodingKeys: String, CodingKey {
        case id
        case isActive = "is_active"
        case type, name, price
        // case priceBefore = "price_before"
        case image, count, total, store, options
    }
}

// MARK: - Option

struct Option: Codable {
    let name: String?
    let id: Int?
    let pivot: Pivot?
}

// MARK: - Pivot

struct Pivot: Codable {
    let productID, optionID, min, max: Int?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case optionID = "option_id"
        case min, max
    }
}

// MARK: - Store

struct BoxStore: Codable {
    let id: Int?
    let name: String?
    let logo: String?
}

// MARK: =========

struct BoxProductsModel {
    let message: String
    let header: HeaderModel
    let product: [ProductModel]

    init(_ model: BoxProductsResponse?) {
        self.message = model?.message ?? ""
        self.header = HeaderModel(model?.data?.box)
        self.product = (model?.data?.products ?? []).map { ProductModel($0) }
    }
}

struct HeaderModel {
    let boxName: String
    let boxId: Int
    init(_ model: BoxHeader?) {
        self.boxName = model?.name ?? ""
        self.boxId = model?.id ?? 0
    }
}

struct ProductModel {
    let id, count, isActive: Int
    let type, price, image, total, name: String
    let store: StoreDetailsModel
    let options: [OptionsModel]
    init(_ model: BoxProductsData?) {
        self.id = model?.id ?? 0
        self.isActive = model?.isActive ?? 0
        self.count = model?.count ?? 0
        self.type = model?.type ?? ""
        self.price = model?.price ?? ""
        self.image = model?.image ?? ""
        self.total = model?.total ?? ""
        self.name = model?.name ?? ""
        self.store = StoreDetailsModel(model?.store)
        self.options = (model?.options ?? []).map { OptionsModel($0) }
    }
}

struct StoreDetailsModel {
    let name: String
    let logo: String
    init(_ model: BoxStore?) {
        self.name = model?.name ?? ""
        self.logo = model?.logo ?? ""
    }
}

struct OptionsModel {
    let name: String
    let id:Int
    init(_ model: Option) {
        self.name = model.name ?? ""
        self.id = model.id ?? 0
    }
}

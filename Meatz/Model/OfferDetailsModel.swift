//
//  OfferDetailsModel.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/20/21.
//

import Foundation

// MARK: - OfferDetailsResponse
struct OfferDetailsResponse: Codable {
    let status, message: String?
    let data: OfferDetailsData?
}

// MARK: - DataClass
struct OfferDetailsData: Codable {
    let id: Int?
    let name, price, priceBefore: String?
    let persons, stocks: Int?
    let images: [String]?
    let content: [String]?
    let store: Store?

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case priceBefore = "price_before"
        case persons, stocks, images, content, store
    }
}

struct OfferDetailsModel {
    let id: Int
    let name: String
    let price: String
    let priceBefore: String
    let persons: Int
    let stocks: Int
    let images: [String]
    let content: [String]
    let store: StoreModel
    
    init(_ model: OfferDetailsResponse?) {
        id = model?.data?.id ?? 0
        name = model?.data?.name ?? ""
        price = model?.data?.price ?? ""
        priceBefore = model?.data?.priceBefore ?? ""
        persons = model?.data?.persons ?? 0
        stocks = model?.data?.stocks ?? 0
        images = model?.data?.images ?? []
        content = model?.data?.content ?? []
        store = StoreModel(model?.data?.store)
    }
}

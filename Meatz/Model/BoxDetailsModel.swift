//
//  BoxDetailsModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/4/21.
//

import Foundation


// MARK: - BoxDetailsResponse
struct BoxDetailsResponse: Codable {
    let status, message: String?
    let data: BoxDetailsData?
}

// MARK: - DataClass
struct BoxDetailsData: Codable {
    let id: Int?
    let name, content, price: String?
    let priceBefore: String?
    let liked: Int?
    let persons, num: Int?
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case id, name, content, price
        case priceBefore = "price_before"
        case liked, persons, num, images
    }
}

// MARK: - Image
struct Image: Codable {
    let id, imageableID: Int?
    let imageableType: String?
    let image: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imageableID = "imageable_id"
        case imageableType = "imageable_type"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


struct BoxDetailsModel{
    let id: Int
    let name, content, price: String
    let priceBefore: String
    let liked: Int
    let persons, num: Int
    let images: [SliderInput]

    init(_ res : BoxDetailsResponse?) {
        let data = res?.data
        id = data?.id ?? 0
        name = data?.name ?? ""
        content = data?.content ?? ""
        price = data?.price ?? ""
        priceBefore = data?.priceBefore ?? ""
        liked = data?.liked ?? 0
        persons = data?.persons ?? 0
        num = data?.num ?? 0
        images = (data?.images ?? []).map({return SliderInput(link: $0.image ?? "")})
    }
}

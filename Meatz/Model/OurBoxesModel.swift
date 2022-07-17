//
//  OurBoxesModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/1/21.
//

import Foundation


// MARK: - OurBoxesResponse
struct OurBoxesResponse: Codable {
    let status, message: String?
    let data: OurBoxesData?
}

// MARK: - DataClass
struct OurBoxesData: Codable {
    let boxes: [Box]?
    let cart: Cart?
}



struct OurBoxesModel{
    let boxes : [BoxModel]
    let cart : CartModel
    init(_ res : OurBoxesResponse?) {
        boxes = (res?.data?.boxes ?? []).map({return BoxModel($0)})
        cart = CartModel(res?.data?.cart)
    }
}

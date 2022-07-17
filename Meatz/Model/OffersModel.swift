//
//  OffersModel.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/19/21.
//

import UIKit

// MARK: - PageResponse
struct OffersResponse: Codable {
    let status, message: String?
    let data: OffersData?
}

// MARK: - DataClass
struct OffersData: Codable {
    let categories: [Category]?
    let boxs: [Box]?
}




struct OffersModel {
    let categories: [CategoryModel]
    let boxs: [BoxModel]
    
    init(_ model: OffersData?) {
        categories = model?.categories?.map({CategoryModel(model: $0)}) ?? []
        boxs = model?.boxs?.map({BoxModel($0)}) ?? []
     }
    
}

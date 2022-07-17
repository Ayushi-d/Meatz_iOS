//
//  SearchModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/4/21.
//

import Foundation


// MARK: - SearchResponse
struct SearchResponse: Codable {
    let status, message: String?
    let data: SearchData?
}

// MARK: - DataClass
struct SearchData: Codable {
    let products: [Product]?
    let stores: [Store]?
}


struct SearchModel{
    let products : [ProductViewModel]
    let stores : [StoreModel]
    init(_ res : SearchResponse?) {
        products = (res?.data?.products ?? []).map({return ProductViewModel($0)})
        stores = (res?.data?.stores ?? []).map({return StoreModel($0)})
    }
}

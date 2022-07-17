//
//  FeaturedStoresModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/30/21.
//

import Foundation

// MARK: - FeaturedStoresResponse
struct FeaturedStoresResponse: Codable {
    let status, message: String?
    let data: FeaturedData?
}

// MARK: - DataClass
struct FeaturedData: Codable {
    let stores: [Store]?
    let ads: [Ad]?
}

struct FeaturedStoresModel{
    let stores : [StoreModel]
    init(_ res : FeaturedStoresResponse?) {
        stores = (res?.data?.stores ?? []).map({return StoreModel($0)})
        
    }
}



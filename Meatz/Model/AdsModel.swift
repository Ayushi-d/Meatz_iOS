//
//  AdsModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/31/21.
//

import Foundation

// MARK: - AdsResponse

struct AdsResponse: Codable {
    let status, message: String?
    let data: AdsData?
}

// MARK: - DataClass

struct AdsData: Codable {
    let id: Int?
    let image: String?
}

struct AdsModel {
    let id: Int
    let image: String

    init(_ res: AdsResponse?) {
        id = res?.data?.id ?? 0
        image = res?.data?.image ?? ""
    }
    
    init(_ id : Int ,_ img : String) {
        self.id = id
        self.image = img
    }
}

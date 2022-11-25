//
//  LikeModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/12/21.
//

import Foundation
// MARK: - LikeResponse
struct LikeResponse: Codable {
    let status, message: String?
    let data: LikeData?
}

// MARK: - DataClass
struct LikeData: Codable {
    let liked: Int?
}


struct LikeModel {
    var isLiked : Bool
    
    init(_ res : LikeResponse?) {
        isLiked = (res?.data?.liked ?? 0) == 1 
    }
}

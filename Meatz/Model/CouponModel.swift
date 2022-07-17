//
//  CouponModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/23/21.
//

import Foundation

// MARK: - CouponResponse

struct CouponResponse: Codable {
    let status, message: String?
    let data: CouponData?
}

// MARK: - DataClass

struct CouponData: Codable {
    let coponID,used : Int?
    let total,discount: Double?
    enum CodingKeys: String, CodingKey {
        case coponID = "copon_id"
        case discount, total,used
    }
}

struct CouponModel {
    let status : Bool
    let message : String
    let coponID: Int
    let discount, total: Double
    let used:Bool

    init(_ res: CouponResponse?) {
        let data = res?.data
        message = res?.message ?? ""
        status = (res?.status ?? "") == "success"
        coponID = data?.coponID ?? 0
        discount = data?.discount ?? 0.0
        total = data?.total ?? 0.0
        used = data?.used == 1
    }
}

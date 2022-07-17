//
//  CheckoutModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/26/21.
//

import Foundation

// MARK: - CheckoutResponse
struct CheckoutResponse: Codable {
    let status, message: String?
    let data: CheckoutData?
}

// MARK: - DataClass
struct CheckoutData: Codable {
    let paymentURL: String?
    let orderID: Int?

    enum CodingKeys: String, CodingKey {
        case paymentURL = "paymentUrl"
        case orderID = "order_id"
    }
}



struct CheckoutModel{
    let paymentURL: String
    var orderID: Int
    var paymentID : String = ""
    var transID : String = ""
    var paymentType: PaymentType = .checkout
    var rechargeAmount: String = ""
    
    init(_ res : CheckoutResponse?) {
        paymentURL = res?.data?.paymentURL ?? ""
        orderID = res?.data?.orderID ?? 0
    }
}

enum PaymentType {
    case checkout
    case rechargeWallet
}

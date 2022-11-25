//
//  PaymentModel.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 10/18/21.
//

import Foundation

// MARK: - PaymentResponse
struct PaymentResponse: Codable {
    let status, message: String?
    let data: PaymentData?
}

// MARK: - DataClass
struct PaymentData: Codable {
    let paymentID, transactionID: String?
    let orderID: Int?

    enum CodingKeys: String, CodingKey {
        case paymentID = "payment_id"
        case transactionID = "transaction_id"
        case orderID = "order_id"
    }
}

struct PaymentModel {
    let message: String
    let orderId: Int
    let paymentId: String
    let transactionID: String
    
    init(_ model: PaymentResponse?) {
        message = model?.message ?? ""
        orderId = model?.data?.orderID ?? 0
        paymentId = model?.data?.paymentID ?? ""
        transactionID = model?.data?.transactionID ?? ""
    }
}

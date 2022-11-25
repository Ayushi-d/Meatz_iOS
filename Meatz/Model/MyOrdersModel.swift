//
//  MyOrdersModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/15/21.
//

import Foundation
// MARK: - MyOrdersResponse
struct MyOrdersResponse: Codable {
    let status, message: String?
    let data: [Order]?
}

// MARK: - Datum
struct Order: Codable {
    let id: Int?
    let code, status: String?
    let canReorder: Int?
    let total, paymentMethod: String?
    let itemsCount: Int?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, code, status
        case canReorder = "can_reorder"
        case total
        case paymentMethod = "payment_method"
        case itemsCount = "items_count"
        case createdAt = "created_at"
    }
}


struct MyOrdersModel{
    let orders : [MyOrderModel]
    init(_ res : MyOrdersResponse?){
        self.orders = (res?.data ?? []).map({return MyOrderModel($0)})
    }
}


struct MyOrderModel : MyOrdersCellViewModel{
    let id: Int
    let code, status: String
    let canReorder: Bool
    let total, paymentMethod: String
    let itemsCount: Int
    let createdAt: String

    init(_ order : Order?) {
        id = order?.id ?? 0
        code = order?.code ?? ""
        status = order?.status ?? ""
        canReorder = (order?.canReorder ?? 0) == 1
        total = order?.total ?? ""
        paymentMethod = order?.paymentMethod ?? ""
        itemsCount = order?.itemsCount ?? 0
        createdAt = order?.createdAt ?? ""
    }
    
    var ID: Int{
        return id
    }
    var orderID: String{
        return "# " + id.toString
    }
    
    var price: String{
        return total + " " + R.string.localizable.kwd()
    }
    
    var orderDate: String{
        return createdAt
    }
    
    var count : String{
        return R.string.localizable.itemsCountLabel() + itemsCount.toString
    }
    
    var statusValue: String{
        return status
    }
    
    var isRorderable: Bool{
        return canReorder
    }
}

//
//  OrderDetailsModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/16/21.
//

import Foundation
// MARK: - OrderDetailsResponse
struct OrderDetailsResponse: Codable {
    let status, message: String?
    let data: OrderData?
}

// MARK: - DataClass
struct OrderData: Codable {
    let id: Int?
    let code, status: String?
    let store: Store?
    let address: DataAddress?
    let createdAt, copon: String?
    let canReorder: Int?
    let canCancel: Int?
    let paymentMethod: String?
    let payment: Payment?
    let products: [ProductOrder]?
    let delivery: DeliveryResponse?

    enum CodingKeys: String, CodingKey {
        case id, code, status, store, address
        case createdAt = "created_at"
        case copon
        case canReorder = "can_reorder"
        case canCancel = "can_cancel"
        case paymentMethod = "payment_method"
        case payment, products, delivery
    }
}



// MARK: - Delivery Response
struct DeliveryResponse: Codable {
    let deliveryType, mode, date, time: String?
    
    enum CodingKeys: String, CodingKey {
        case deliveryType = "delivery_type"
        case mode, date, time
    }
}

// MARK: - Delivery
struct Delivery: Codable {
    let deliveryType: String
    let mode: String
    let date: String
    let time: String
    
    init(_ model: DeliveryResponse?)  {
        deliveryType = model?.deliveryType ?? "-"
        mode = model?.mode ?? ""
        date = model?.date ?? "-"
        time = model?.time ?? "-"
    }
}


// MARK: - DataAddress
struct DataAddress: Codable {
    let id: Int?
    let fullAddress: String?
    let addressName: String?
    let area: City?
    let address: Address?

    enum CodingKeys: String, CodingKey {
        case id
        case addressName = "address_name"
        case area, address
        case fullAddress = "full_address"
    }
}

// MARK: - AddressAddress
//struct AddressAddress: Codable {
//    let areaID, addressName, block, street: String?
//    let buildingNumber, levelNo, avenue, apratmentNo: String?
//    let notes: String?
//
//    enum CodingKeys: String, CodingKey {
//        case areaID = "area_id"
//        case addressName = "address_name"
//        case block, street
//        case buildingNumber = "building_number"
//        case levelNo = "level_no"
//        case avenue
//        case apratmentNo = "apratment_no"
//        case notes
//    }
//}


// MARK: - Payment
struct Payment: Codable {
    let discount, subtotal, delivery, total: String?
    let paymentMethod: String?
    let paymentID, transactionID: String?

    enum CodingKeys: String, CodingKey {
        case discount, subtotal, delivery, total
        case paymentMethod = "payment_method"
        case paymentID = "payment_id"
        case transactionID = "transaction_id"
    }
}

// MARK: - ProductOrder
struct ProductOrder: Codable {
    let image: String?
    let title: String?
    let count: Int?
    let persons: Int?
    let name, total: String?
    let store : Store?
    let options: [OrderOption]?
}

// MARK: - OrderOption
struct OrderOption: Codable {
    let id: Int?
    let optionID: Int?
    let name, price, parentName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case optionID = "option_id"
        case name, price
        case parentName = "parent_name"
    }
}


struct OrderDetailsModel{
    let id : Int
    let paymentInfo : PaymentInfo
    let isCashPayment : Bool
    let store : StoreModel
    let address : AddressModel
    var products : [OrderProductModel] = []
    let code, status: String
    let createdAt, copon: String
    let canReorder: Bool
    let canCancel: Bool
    let delivery: Delivery
    let message: String
    
    init(_ res : OrderDetailsResponse?) {
        message = res?.message ?? ""
        id = res?.data?.id ?? 0
        code = res?.data?.code ?? ""
        status = res?.data?.status ?? ""
        createdAt = res?.data?.createdAt ?? ""
        copon = res?.data?.copon ?? ""
        canReorder = (res?.data?.canReorder ?? 0) == 1 
        store = StoreModel(res?.data?.store)
        address = AddressModel(res?.data?.address)
        paymentInfo = PaymentInfo(res?.data?.payment)
        isCashPayment = (res?.data?.paymentMethod ?? "") == "cash"
        products = (res?.data?.products ?? []).map({return OrderProductModel($0)})
        delivery = Delivery(res?.data?.delivery)
        canCancel = res?.data?.canCancel ?? 0 == 1 ? true : false
    }
}


struct PaymentInfo{
    let discount, subtotal, delivery, total: String
    let paymentMethod: String
    let paymentID, transactionID: String
    
    init(_ payment : Payment?) {
        let discountDash = payment?.discount == "0.000" ? "" : "-"
        discount = discountDash + (payment?.discount ?? "").addCurrency()
        subtotal = (payment?.subtotal ?? "").addCurrency()
        delivery = (payment?.delivery ?? "").addCurrency()
        total = payment?.total ?? ""
        paymentMethod = payment?.paymentMethod ?? ""
        paymentID = payment?.paymentID ?? R.string.localizable.nA()
        transactionID = payment?.transactionID ?? R.string.localizable.nA()
    }
}



struct OrderProductModel : OrderProductCellViewModel{

    let image: String
    let title: String
    let count: Int
    let persons: Int
    let name : OrderItemType
    let total: String
    let store : StoreModel
    let options: [OrderOptionModel]
    
    
    init(_ product : ProductOrder?) {
        image = product?.image ?? ""
        title = product?.title ?? ""
        count = product?.count ?? 0
        persons = product?.persons ?? 0
        name = OrderItemType(rawValue:product?.name ?? "") ?? .null
        total = product?.total ?? ""
        options = (product?.options ?? []).map({return OrderOptionModel($0)})
        store  = StoreModel(product?.store)
    }
    var storeName: String{
        return store.name
    }
    
    var storeImage: String{
        return store.image
    }
    
    var priceString: String{
        return total
    }
    
    var quantityString: String{
        return R.string.localizable.quantityLabel() + count.toString
    }
    
    var productImage: String{
        return image
    }
    
    var optionsString: String{
        return options.map({return $0.name}).joined(separator: ",")
    }
    
    var productName: String
    {
        return title
    }
    var ItemType: OrderItemType{
        return name
    }
    
    var personsCount: String{
        return persons.toString + " " + R.string.localizable.persons()
    }
}


enum OrderItemType : String {
    case null
    case product
    case box
    case specialBox = "special_box"
}
struct OrderOptionModel{
    let id: Int
    let optionID: Int
    let name, price, parentName: String

    init(_ option : OrderOption?) {
        id = option?.id ?? 0
        optionID = option?.optionID ?? 0
        name = option?.name ?? ""
        price = option?.price ?? ""
        parentName = option?.parentName ?? ""
    }
}

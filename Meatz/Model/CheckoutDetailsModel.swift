//
//  CheckoutDetailsModel.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 10/4/21.
//

import Foundation

// MARK: - DeliveryResponse
struct CehckoutDetailsResponse: Codable {
    let status, message: String?
    let data: CehckoutDetailsResponseData?
}

// MARK: - DataClass
struct CehckoutDetailsResponseData: Codable {
    let discount, subtotal, expressDeliveryCost, delivery, total, wallet: Double?
    let expressDelivery: Int?
    let expressDeliveryMessage: String?
    let dates: DatesResponse?
    let periods: [PeriodResponse]?

    enum CodingKeys: String, CodingKey {
        case discount, subtotal
        case expressDelivery = "express_delivery"
        case expressDeliveryCost = "express_delivery_cost"
        case expressDeliveryMessage = "express_delivery_message"
        case delivery, total, wallet, dates, periods
    }
}

// MARK: - Dates
struct DatesResponse: Codable {
    let start: String?
    let days: [DayResponse]?
    let end, year: String?
}

struct DatesModel: Codable {
    let start: String
    let days: [DayModel]
    let end, year: String
    
    init(_ model: DatesResponse?) {
        start = model?.start ?? ""
        days = model?.days?.map({DayModel($0)}) ?? []
        end = model?.end ?? ""
        year = model?.year ?? ""
    }
}

// MARK: - Day
struct DayResponse: Codable {
    let weekday, day, date: String?
    let today, active: Int?
}

// MARK: - Day
struct DayModel: Codable {
    let weekday, day, date: String
    let today, active: Bool
    
    init(_ model: DayResponse?) {
        weekday = model?.weekday ?? ""
        day = model?.day ?? ""
        date = model?.date ?? ""
        today = model?.today ?? 0 == 1 ? true : false
        active = model?.active ?? 0 == 1 ? true : false
    }
}


// MARK: - Period
struct PeriodResponse: Codable {
    let id: Int?
    let from, to: String?
    let active: Int?
}

struct PeriodModel: Codable {
    let id: Int
    let from, to: String
    let active: Bool
    
    init(_ model: PeriodResponse?) {
        id = model?.id ?? 0
        from = model?.from ?? ""
        to = model?.to ?? ""
        active = model?.active ?? 0 == 1 ? true : false
    }
}


struct CehckoutDetailsModel: Codable {
    let  subtotal, expressDeliveryCost, wallet: Double
    var delivery: Double
    var total: Double
    var discount: Double
    let expressDelivery: Bool
    let expressDeliveryMessage: String
    let dates: DatesModel
    let periods: [PeriodModel]
    let periodTitle: String
    
    init(_ model: CehckoutDetailsResponse?) {
        discount = model?.data?.discount ?? 0.0
        subtotal = model?.data?.subtotal ?? 0.0
        expressDeliveryCost =  0.0
        delivery = 0.0
        total = model?.data?.total ?? 0.0
        wallet = model?.data?.wallet ?? 0.0
        expressDelivery = model?.data?.expressDelivery ?? 0 == 1 ? true : false
        expressDeliveryMessage = model?.data?.expressDeliveryMessage ?? ""
        dates = DatesModel(model?.data?.dates)
        periods = model?.data?.periods?.map({PeriodModel($0)}) ?? []
        
        periodTitle = dates.start + " " + R.string.localizable.to() + " " + dates.end + " " + dates.year
    }
}

//
//  AreasModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import Foundation

// MARK: - AreasResponse

struct AreasResponse: Codable {
    let status, message: String?
    let data: [Area]?
}

// MARK: - AreaData

struct Area: Codable {
    let id: Int?
    let cityID: Int?
    let name: String?
    let delivery : Double?
    let cities: [City]?

    enum CodingKeys: String, CodingKey {
        case id
        case delivery
        case cityID = "city_id"
        case name, cities
    }
}

struct AreasModel {
    let areas: [AreaModel]
    init(_ res: AreasResponse?) {
        areas = (res?.data ?? []).map { AreaModel($0) }
    }
}

struct AreaModel {
    let id: Int
    let cityID: Int
    let name: String
    let cities: [CityModel]
    var isExpanded : Bool = false 
    init(_ area: Area?) {
        id = area?.id ?? 0
        cityID = area?.cityID ?? 0
        name = area?.name ?? ""
        cities = (area?.cities ?? []).map { CityModel($0) }
    }
}

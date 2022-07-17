//
//  MyAddressModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import Foundation

// MARK: - MyAddressResponse

struct MyAddressResponse: Codable {
    let status, message: String?
    let data: [MyAddressData]?
}

// MARK: - Datum

struct MyAddressData: Codable {
    let id: Int?
    let addressName: String?
    let area: City?
    let address: Address?

    enum CodingKeys: String, CodingKey {
        case id
        case addressName = "address_name"
        case area, address
    }
}

// MARK: - Address

struct Address: Codable {
    let addressName, areaID, block, apartmentNo: String?
    let houseNumber, levelNo, notes, street: String?
    let avenue : String?

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case areaID = "area_id"
        case block
        case apartmentNo = "apartment_no"
        case houseNumber = "house_number"
        case levelNo = "level_no"
        case notes, street
        case avenue

    }
}

// MARK: - Area

struct City: Codable {
    let id: Int?
    let cityID: Int?
    let name: String?
    let delivery : Double?
    let deliveryExpress: Double?
    enum CodingKeys: String, CodingKey {
        case id
        case cityID = "city_id"
        case name
        case delivery
        case deliveryExpress = "delivery_express"
    }
}

struct MyAddressModel {
    let message : String
    let addresses: [AddressModel]
    init(_ res: MyAddressResponse?) {
        message = res?.message ?? ""
        addresses = (res?.data ?? []).map { AddressModel($0) }
    }
}

struct AddressModel : MyAddressCellViewModel, CustomStringConvertible {
    let id, areaID: Int
    let addressName: String
    let area: CityModel
    let block, apartmentNo: String
    let houseNumber, levelNo, notes, street: String
    let guestAddress:String
    
    var description: String {
        return addressName
    }

    init(_ address: MyAddressData?) {
        id = address?.id ?? 0
        addressName = address?.addressName ?? ""
        area = CityModel(address?.area)
        areaID = (address?.address?.areaID ?? "0").toInt()
        block = address?.address?.block ?? ""
        apartmentNo = address?.address?.apartmentNo ?? ""
        houseNumber = address?.address?.houseNumber ?? ""
        levelNo = address?.address?.levelNo ?? ""
        notes = address?.address?.notes ?? ""
        street = address?.address?.street ?? ""
        guestAddress = address?.addressName ?? ""
    }
    
    init(_ address : DataAddress?) {
        id = address?.id ?? 0
        addressName = address?.addressName ?? ""
        area = CityModel(address?.area)
        areaID = (address?.address?.areaID ?? "0").toInt()
        block = address?.address?.block ?? ""
        apartmentNo = address?.address?.apartmentNo ?? ""
        houseNumber = address?.address?.houseNumber ?? ""
        levelNo = address?.address?.levelNo ?? ""
        notes = address?.address?.notes ?? ""
        street = address?.address?.street ?? ""
        guestAddress = address?.fullAddress ?? ""
    }
    
    var title: String{
        return addressName
    }
    
    var desc: String{
        let floor = levelNo.isEmpty ? "" : R.string.localizable.flooR()
        return area.name + " " +
               R.string.localizable.blocK() + " " + block + " " +
               R.string.localizable.streeT() + " " + street + " \n" +
               R.string.localizable.buildinG() + " " + houseNumber + " " +
                floor + " " + levelNo
    }
    
    var orderDetailsAddress:String{
        let floor = levelNo.isEmpty ? "" : R.string.localizable.flooR() + " " +  levelNo
        return area.name + " " +
               R.string.localizable.blocK() + " " + block + " " +
               R.string.localizable.streeT() + " " + street + " " +
               R.string.localizable.buildinG() + " " + houseNumber + " " +
                floor
    }
    
    var ItemID: Int{
        return id
    }
}

struct CityModel {
    let id: Int
    let cityID: Int
    let name: String
    let delivery : Double
    let deliveryExpress: Double
    
    init(_ city: City?) {
        id = city?.id ?? 0
        cityID = city?.cityID ?? 0
        name = city?.name ?? ""
        delivery = city?.delivery ?? 0
        deliveryExpress = city?.deliveryExpress ?? 0.0
    }
}

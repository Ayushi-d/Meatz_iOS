//
//  AddressParameters.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import Foundation

struct AddressParameters: Parameters {
    var area_ID: Int = 0
    var areaName: String = ""
    var addressName: String = ""
    var block: String = ""
    var street: String = ""
    var houseNumber: String = ""
    var aptNum: String = "" // apt no
    var floorNo: String = ""
    var notes: String = ""
    var email: String = ""
    var mobile: String = ""
    var customerName = ""
    var deliveryCost: Double = 0.0
    var deliveryExpress: Double = 0.0
    
    var address: AddressModel! {
        didSet {
           
            area_ID = address.areaID
            addressName = address.addressName
            block = address.block
            street = address.street
            houseNumber = address.houseNumber
            aptNum = address.apartmentNo
            floorNo = address.levelNo
            notes = address.notes
            deliveryCost = address.area.delivery
            deliveryExpress = address.area.deliveryExpress
        }
    }

    var desc: String {
        let floor = floorNo.isEmpty ? " " : R.string.localizable.flooR() + " " + floorNo
        let building = houseNumber.isEmpty ? " " : R.string.localizable.buildinG() + " " + houseNumber
        return addressName + " " +
            R.string.localizable.blocK() + " " + block + " " +
            R.string.localizable.streeT() + " " + street + " \n" +
            building + " " + aptNum + " " +
            floor
    }

    var descAddressForGuest: String {
        let floor = floorNo.isEmpty ? " " : R.string.localizable.flooR() + " " + floorNo
        let building = houseNumber.isEmpty ? " " : R.string.localizable.buildinG() + " " + houseNumber
        
        return areaName + " " + R.string.localizable.blocK() + " " + block + " " +
            R.string.localizable.streeT() + " " + street + " " +
            building + " " + floor
    }

    var body: [String: Any] {
        return ["email": email,
                "mobile": mobile,
                "username": customerName,
                "area_id": area_ID,
                "address_name": addressName,
                "block": block,
                "street": street,
                "house_number": houseNumber,
                "level_no": floorNo,
                "notes": notes,
                "apartment_no": aptNum]
    }
}

enum AddressFieldType {
    case customerName(String)
    case email(String)
    case phone(String)
    case addressName(String)
    case block(String)
    case street(String)
    case houseNumber(String)
    case floorNo(String)
    case notes(String)
    case area(Int)
    case aptNum(String)
    case areaName(String)
}

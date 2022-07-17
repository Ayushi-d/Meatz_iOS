//
//  ContactInfoModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import Foundation

// MARK: - ContactInfoResponse
struct ContactInfoResponse: Codable {
    let status, message: String?
    let data: ContactInfoData?
}

// MARK: - DataClass
struct ContactInfoData: Codable {
    let whatsapp, mobile, email: String?
    let facebook: String?
    let twitter: String?
    let instagram: String?
    let address, lat, lng: String?
}

struct ContactInfoModel{
    let whatsapp, mobile, email: String?
    let facebook, twitter, instagram: String?
    let address, lat, lng: String?
    
    init(_ model: ContactInfoData) {
        whatsapp = model.whatsapp
        mobile = model.mobile
        email = model.email
        facebook = model.facebook
        twitter = model.twitter
        instagram = model.instagram
        address = model.address
        lat = model.lat
        lng = model.lng
    }
}

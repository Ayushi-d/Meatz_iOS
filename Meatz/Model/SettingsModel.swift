//
//  SettingsModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import Foundation

// MARK: - SettingsResponse
struct SettingsResponse: Codable {
    let status, message: String?
    let data: [SettingsData]?
}

// MARK: - Datum
struct SettingsData: Codable {
    let id: Int?
    let title,image: String?
}


struct SettingsModel{
    let id: Int
    let title,image: String
    
    init(_ model: SettingsData?) {
        id = model?.id ?? 0
        title = model?.title ?? ""
        image = model?.image ?? ""
    }
}

//
//  SettingDetailsModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import Foundation

// MARK: - SettingDetailsResponse
struct PageResponse: Codable {
    let status, message: String?
    let data: PageData?
}

// MARK: - DataClass
struct PageData: Codable {
    let id: Int?
    let type, title, content: String?
    let image: String?
}

struct PageModel{
    let id: Int?
    let title, content: String?
   
    
    init(_ model: PageData) {
        id = model.id
        title = model.title
        content = model.content
    }
}

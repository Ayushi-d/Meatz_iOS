//
//  MyBoxesModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/14/21.
//

import Foundation

// MARK: - MyBoxesResponse
struct MyBoxesResponse: Codable {
    let status, message: String
    let data: [BoxInfo]?
}

// MARK: - BoxInfo
struct BoxInfo: Codable {
    let id, isActive: Int
    let name: String
    let itemsCount: Int
    let total: String

    enum CodingKeys: String, CodingKey {
        case id
        case isActive = "is_active"
        case name
        case itemsCount = "items_count"
        case total
    }
}

struct MyBoxesModel{
    let status, message: String
    let boxes:[BoxesDataModel]
    
    init(_ model:MyBoxesResponse ) {
        self.status = model.status
        self.message = model.message
        self.boxes = (model.data ?? []).map({BoxesDataModel($0)})
    }
}


struct BoxesDataModel : FilterTableViewCellViewModel{
    let id, isActive: Int
    let name: String
    let itemsCount: Int
    let total: String
    
    init(_ model:BoxInfo? ) {
        self.id = model?.id ?? 0
        self.isActive = model?.isActive ?? 0
        self.name = model?.name ?? ""
        self.itemsCount = model?.itemsCount ?? 0
        self.total = model?.total ?? ""
    }

    var optionTitle: String{
        return name
    }
}

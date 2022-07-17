//
//  NotificationsModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import Foundation

// MARK: - NotificationsResponse
struct NotificationsResponse: Codable {
    let status, message: String?
    let data: [Notification]?
    let pagination: Pagination?
}

// MARK: - NotificaionsData
struct Notification: Codable {
    let id: Int?
    let text : String?
    let model: NotificationItemType?
    let modelID: Int?
    let image: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, text, model
        case modelID = "model_id"
        case image
        case createdAt = "created_at"
    }
}


struct NotificationsModel {
    
    let notifications : [NotificationModel]
    init(_ res : NotificationsResponse?) {
        notifications = (res?.data ?? []).map({return NotificationModel($0)})
    }
}

struct NotificationModel : NotificationCellViewModel{

    private let id: Int
    private let text : String
    private let model: NotificationItemType
    private let modelID: Int
    private let image: String
    private let createdAt: String

    init(_ not : Notification?) {
        id = not?.id ?? 0
        text = not?.text ?? ""
        model = not?.model ?? .none
        modelID = not?.modelID ?? 0
        image = not?.image ?? ""
        createdAt = not?.createdAt ?? ""
    }
    
    var ID: Int{
        return id
    }
    
    var notificationContent: String{
        return text
    }
    
    var type: NotificationItemType{
        return model
    }
    
    var itemID: Int{
        return modelID
    }
    
    var notificationImage: String{
        return image
    }
    
    var date: String{
        return createdAt
    }
    
}

enum NotificationItemType : String,Codable{
    case product
    case order
    case none
}

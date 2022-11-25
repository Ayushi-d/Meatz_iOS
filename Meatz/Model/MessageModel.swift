//
//  MessageModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/5/21.
//

import Foundation

struct MessageResponse: Codable {
    let status, message: String?
    //let data: CartData
}


struct MessageModel{
    let status : Bool
    let message : String
    init(_ res : MessageResponse?) {
        status = (res?.status ?? "") == "success"
        message = res?.message ?? ""
    }
}

struct AddItemToBoxesResponse: Codable {
    let status, message: String?
    let data : BoxInfo?
}


struct AddItemToBoxesModel{
    let status : Bool
    let message : String
    let boxToClear : BoxesDataModel
    init(_ res : AddItemToBoxesResponse?) {
        status = (res?.status ?? "") == "success"
        message = res?.message ?? ""
        boxToClear = BoxesDataModel(res?.data)
    }
}




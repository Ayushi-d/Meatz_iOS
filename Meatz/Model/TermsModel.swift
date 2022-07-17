//
//  TermsModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/29/21.
//

import Foundation

// MARK: - TermsResponse
struct TermsResponse: Codable {
    let status, message: String?
    let data: TermsData?
}

// MARK: - DataClass
struct TermsData: Codable {
    let id: Int?
    let type, title, content: String?
    let image: String?
}


struct TermsModel{
    let title : String
    let content : String
    init(_ res : TermsResponse?) {
        title = res?.data?.title ?? ""
        content = res?.data?.content ?? ""
    }
}

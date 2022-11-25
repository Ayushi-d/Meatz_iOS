//
//  WalletModel.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/22/21.
//

import Foundation

struct WalletResponse: Codable {
    let status, message: String?
    let data: WalletData?
}

// MARK: - DataClass
struct WalletData: Codable {
    let wallet: String?
    let cards: [RechargePackage]?
}

// MARK: - Card
struct RechargePackage: Codable {
    let id, sort: Int?
    let price: String?
}


// MARK: - Card
struct RechargePackageModel {
    let id: Int
    let sort: Int
    let price: String
    let decimal: String
    let allPrice: String
    
    init(_ model: RechargePackage?) {
        id = model?.id ?? 0
        sort = model?.sort ?? 0
        allPrice = model?.price ?? ""
        if let prices = model?.price?.components(separatedBy: ".")  {
            price = prices[0]
            decimal = prices[1]
        } else {
            price = model?.price ?? ""
            decimal = "00"
        }
    }
    
}

struct WalletModel {
    let balance: String
    let packages: [RechargePackageModel]
    
    init(_ model: WalletResponse?) {
        balance = model?.data?.wallet ?? ""
        packages = model?.data?.cards?.map({RechargePackageModel($0)}) ?? []
    }
}

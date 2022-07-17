//
//  WalletRepo.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/22/21.
//

import Foundation

class WalletRepo: WalletRepoProtocol {
    func getWallet(_ completion: @escaping (Result<WalletModel, ResultError>) -> Void) {
        
        HomeApi.myWallet.sendRequst(data: WalletResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(WalletModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func rechargeWallet(_ params: Parameters, _ completion: @escaping (Result<CheckoutModel, ResultError>) -> Void) {
        HomeApi.rechargeWallet(params).sendRequst(data: CheckoutResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(CheckoutModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

protocol WalletRepoProtocol {
    func getWallet( _ completion: @escaping (Result<WalletModel, ResultError>) -> Void)
    
    func rechargeWallet(_ params: Parameters, _ completion: @escaping (_ result: Result<CheckoutModel, ResultError>) -> Void)
}


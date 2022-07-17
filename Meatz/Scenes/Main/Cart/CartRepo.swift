//
//  CartRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//

import Foundation

final class CartRepo: CartRepoProtocol {
    func didRecieveCartItems(_ params: Parameters?, _ completion: @escaping (Result<CartDataModel, ResultError>) -> Void) {
        HomeApi.cart(params).sendRequst(data: CartResponse.self) { result in
            self.handleReponse(result, completion)
        }
    }

    func deletItem(_ params: Parameters, _ completion: @escaping (Result<CartDataModel, ResultError>) -> Void) {
        HomeApi.deleteCartItem(params).sendRequst(data: CartResponse.self) { result in
            self.handleReponse(result, completion)
        }
    }

    fileprivate func handleReponse(_ result: ResultStatuts<CartResponse>, _ completion: @escaping (Result<CartDataModel, ResultError>) -> Void) {
        switch result {
        case .success(let response):
            completion(.success(CartDataModel(response)))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

protocol CartRepoProtocol: BoxDetailsRepoProtocol {
    func didRecieveCartItems(_ params: Parameters?, _ completion: @escaping (_ response: Result<CartDataModel, ResultError>) -> Void)
    func deletItem(_ params: Parameters, _ completion: @escaping (_ res: Result<CartDataModel, ResultError>) -> Void)
}

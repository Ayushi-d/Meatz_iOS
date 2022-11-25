//
//  CheckoutRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/23/21.
//

import Foundation

final class CheckoutRepo: CheckoutRepoProtocol {

    func getCheckoutDetails( _ completion: @escaping (Result<CehckoutDetailsModel, ResultError>) -> Void) {
        HomeApi.chekcoutDetails.sendRequst(data: CehckoutDetailsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(CehckoutDetailsModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func applyCoupon(_ params: Parameters, _ completion: @escaping (_ result: Result<CouponModel, ResultError>) -> Void) {
        HomeApi.coupon(params).sendRequst(data: CouponResponse.self) { result in
            switch result {
            case .success(let response):
                let model = CouponModel(response)
                if model.status {
                    completion(.success(model))
                } else {
                    completion(.failure(.messageError(model.message)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func checkout(_ params: Parameters, _ completion: @escaping (Result<CheckoutModel, ResultError>) -> Void) {
        HomeApi.checkout(params).sendRequst(data: CheckoutResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(CheckoutModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol CheckoutRepoProtocol: MyAddressRepoProtocol {
    
    func getCheckoutDetails(_ completion: @escaping (_ result: Result<CehckoutDetailsModel, ResultError>) -> Void)
    
    func applyCoupon(_ params: Parameters, _ completion: @escaping (_ result: Result<CouponModel, ResultError>) -> Void)

    func checkout(_ params: Parameters, _ completion: @escaping (_ result: Result<CheckoutModel, ResultError>) -> Void)
}

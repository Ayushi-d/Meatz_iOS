//
//  OrderDetailsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/16/21.
//

import Foundation

final class OrderDetailsRepo: OrderDetailsRepoProtocol {
    func getOrder(with id: Int, _ completion: @escaping (Result<OrderDetailsModel, ResultError>) -> Void) {
        HomeApi.orderDetails(id).sendRequst(data: OrderDetailsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(OrderDetailsModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelOrder(with id: Int, _ completion: @escaping (Result<OrderDetailsModel, ResultError>) -> Void) {
        HomeApi.cancelOrder(orderId: id).sendRequst(data: OrderDetailsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(OrderDetailsModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol OrderDetailsRepoProtocol: MyOrdersRepoProtocol {
    func getOrder(with id: Int, _ completion: @escaping (_ result: Result<OrderDetailsModel, ResultError>) -> Void)
    
    func cancelOrder(with id: Int, _ completion: @escaping (_ result: Result<OrderDetailsModel, ResultError>) -> Void)
}

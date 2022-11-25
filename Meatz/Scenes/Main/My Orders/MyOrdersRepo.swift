//
//  MyOrdersRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/15/21.
//

import Foundation

final class MyOrdersRepo: MyOrdersRepoProtocol {}

protocol MyOrdersRepoProtocol: class {
    func getOrders(_ completion: @escaping (_ res: Result<MyOrdersModel, ResultError>) -> Void)
    func reorder(_ id : Int , compleiton : @escaping(_ res : Result<CartDataModel,ResultError>)->Void)
}

extension MyOrdersRepoProtocol{
    func getOrders(_ completion: @escaping (Result<MyOrdersModel, ResultError>) -> Void) {
        HomeApi.orders.sendRequst(data: MyOrdersResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(MyOrdersModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func reorder(_ id: Int, compleiton: @escaping (Result<CartDataModel, ResultError>) -> Void) {
        HomeApi.reorder(id).sendRequst(data: CartResponse.self) { (result) in
            switch result{
            case .success(let response):
                let model = CartDataModel(response)
                if model.status{
                    compleiton(.success(model))
                    print("aaaaa",model,"bbbb")
                }else{
                    compleiton(.failure(.messageError(model.message)))
                }
            case .failure(let error):
                compleiton(.failure(error))
            }
        }
    }
}

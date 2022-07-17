//
//  ProductDetailsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import Foundation

final class ProductDetailsRepo: ProductDetailsRepoProtcol {
    func getProduct(with id: Int, _ completion: @escaping (Result<ProductDetailsModel, ResultError>) -> Void) {
        HomeApi.product(id).sendRequst(data: ProductDetailsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(ProductDetailsModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addItemToBoxes(_ params: Parameters, _ completion: @escaping (Result<AddItemToBoxesModel, ResultError>) -> Void) {
        HomeApi.addToBoxes(params).sendRequst(data: AddItemToBoxesResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(AddItemToBoxesModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func clearBox(with id: Int, _ completion: @escaping (Result<MessageModel, ResultError>) -> Void) {
        HomeApi.clearBox(id).sendRequst(data: MessageResponse.self) {[weak self] (result) in
            self?.handleResult(result, completion)
        }
    }
    
    func clearCart(_ completion: @escaping (Result<MessageModel, ResultError>) -> Void) {
        HomeApi.clearCart.sendRequst(data: MessageResponse.self) {[weak self] (result) in
            self?.handleResult(result, completion)
        }
    }
    
    fileprivate func handleResult(_ result : ResultStatuts<MessageResponse>,_ completion : @escaping (_ result: Result<MessageModel, ResultError>) -> Void){
        switch result{
        case .success(let response):
            completion(.success(MessageModel(response)))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

protocol ProductDetailsRepoProtcol: WhishlistRepoProtocol, BoxDetailsRepoProtocol {
    func getProduct(with id: Int, _ completion: @escaping (_ result: Result<ProductDetailsModel, ResultError>) -> Void)
    func addItemToBoxes(_ params: Parameters, _ completion: @escaping (_ result: Result<AddItemToBoxesModel, ResultError>) -> Void)
    func clearBox(with id : Int ,_ completion: @escaping (_ result: Result<MessageModel, ResultError>) -> Void)
    func clearCart(_ completion: @escaping (_ result: Result<MessageModel, ResultError>) -> Void)
}

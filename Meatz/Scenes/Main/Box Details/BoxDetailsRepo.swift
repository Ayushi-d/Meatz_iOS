//
//  BoxDetailsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/4/21.
//

import Foundation

final class BoxDetailsRepo: BoxDetailsRepoProtocol {}

protocol BoxDetailsRepoProtocol: class {
    func getBoxDetails(_ id: Int, _ completion: @escaping (_ res: Result<BoxDetailsModel, ResultError>) -> Void)
    func addToCart(_ params: Parameters, _ completion: @escaping (_ res: Result<MessageModel, ResultError>) -> Void)
}

extension BoxDetailsRepoProtocol {

    func getBoxDetails(_ id: Int, _ completion: @escaping (Result<BoxDetailsModel, ResultError>) -> Void) {
        HomeApi.box(id).sendRequst(data: BoxDetailsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(BoxDetailsModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addToCart(_ params: Parameters, _ completion: @escaping (Result<MessageModel, ResultError>) -> Void) {
        HomeApi.addToCart(params).sendRequst(data: MessageResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(MessageModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

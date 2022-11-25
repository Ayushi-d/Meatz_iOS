//
//  BoxProductsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/15/21.
//

import Foundation

final class BoxProductsRepo: BoxProductsRepoProtocol {
    func didRecieveProducts(with id: Int, _ completion: @escaping (Result<BoxProductsModel, ResultError>) -> Void) {
        HomeApi.boxProducts(id).sendRequst(data: BoxProductsResponse.self) { result in
            self.handleReponse(result, completion)
        }
    }

    func deletItem(with id: Int, _ params: Parameters, _ completion: @escaping (Result<BoxProductsModel, ResultError>) -> Void) {
        HomeApi.deleteProductFromBox(id, params).sendRequst(data: BoxProductsResponse.self) { result in
            self.handleReponse(result, completion)
        }
    }

    fileprivate func handleReponse(_ result: ResultStatuts<BoxProductsResponse>, _ completion: @escaping (Result<BoxProductsModel, ResultError>) -> Void) {
        switch result {
        case .success(let response):
            completion(.success(BoxProductsModel(response)))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

protocol BoxProductsRepoProtocol: class {
    func didRecieveProducts(with id: Int, _ completion: @escaping (_ response: Result<BoxProductsModel, ResultError>) -> Void)
    func deletItem(with id: Int, _ params: Parameters, _ completion: @escaping (_ res: Result<BoxProductsModel, ResultError>) -> Void)
}

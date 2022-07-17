//
//  OffersRepo.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/19/21.
//

import Foundation

final class OffersRepo: OffersRepoProtocol {
    
    func getOffersData(parameter: Parameters, _ completion: @escaping (Result<OffersModel, ResultError>) -> Void) {
        HomeApi.offers(parameter).sendRequst(data: OffersResponse.self) {  result in
            switch result {
            case .success(let response):
                completion(.success(OffersModel(response.data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

protocol OffersRepoProtocol: class {
    func getOffersData(parameter: Parameters ,_ completion: @escaping (_ result: Result<OffersModel, ResultError>) -> Void)
}

//
//  AdsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/31/21.
//

import Foundation

final class AdsRepo: AdsRepoProtocol {
    func getAds(_ completion: @escaping (Result<AdsModel, ResultError>) -> Void) {
        HomeApi.ads.sendRequst(data: AdsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(AdsModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol AdsRepoProtocol: AnyObject {
    func getAds(_ completion: @escaping (_ res: Result<AdsModel, ResultError>) -> Void)
}


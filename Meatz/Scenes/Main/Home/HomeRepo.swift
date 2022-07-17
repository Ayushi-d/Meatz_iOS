//
//  HomeRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/30/21.
//

import Foundation

final class HomeRepo: HomeRepoProtocol {
    func getHomeData(_ completion: @escaping (Result<HomeModel, ResultError>) -> Void) {
        HomeApi.home.sendRequst(data: HomeResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(HomeModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol HomeRepoProtocol: class {
    func getHomeData(_ completion: @escaping (_ result: Result<HomeModel, ResultError>) -> Void)
}

//
//  SearchRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/4/21.
//

import Foundation

final class SearchRepo: SearchRepoProtocol {
    func getSearch(_ params: Parameters, _ completion: @escaping (Result<SearchModel, ResultError>) -> Void) {
        HomeApi.search(params).sendRequst(data: SearchResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(SearchModel(response)))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}

protocol SearchRepoProtocol: class {
    func getSearch(_ params: Parameters, _ completion: @escaping (_ res: Result<SearchModel, ResultError>) -> Void)
}

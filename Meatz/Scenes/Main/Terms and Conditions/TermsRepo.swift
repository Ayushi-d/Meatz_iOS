//
//  TermsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/29/21.
//

import Foundation

final class TermsRepo: TermsRepoProtocol {
    func getTerms(_ completion: @escaping (Result<TermsModel, ResultError>) -> Void) {
        HomeApi.terms.sendRequst(data: TermsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(TermsModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol TermsRepoProtocol: class {
    func getTerms(_ completion: @escaping (_ res: Result<TermsModel, ResultError>) -> Void)
}

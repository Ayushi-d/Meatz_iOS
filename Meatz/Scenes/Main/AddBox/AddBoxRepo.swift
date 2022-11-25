//
//  AddBoxRepo.swift
//  Meatz
//
//  Created by Nabil Elsherbene on 4/15/21.
//

import Foundation
final class addBoxRepo: AddBoxRepoProtocol {
    func addBox(_ params: Parameters, _ completion: @escaping (Result<SuccessModel, ResultError>) -> Void) {
        HomeApi.addBox(params).sendRequst(data: SuccessModel.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol AddBoxRepoProtocol {
    func addBox(_ params: Parameters, _ completion: @escaping (_ res: Result<SuccessModel, ResultError>) -> Void)
}

//
//  ChangePassRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/12/21.
//

import Foundation

final class ChangePassRepo: ChangePassRepoProtocol {
    func changePass(_ params: Parameters, _ completion: @escaping (Result<MessageModel, ResultError>) -> Void) {
        HomeApi.changePass(params).sendRequst(data: MessageResponse.self) { result in
            switch result {
            case .success(let response):
                let model = MessageModel(response)
                if model.status {
                    completion(.success(model))
                } else {
                    completion(.failure(.messageError(model.message)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol ChangePassRepoProtocol: class {
    func changePass(_ params: Parameters, _ completion: @escaping (_ res: Result<MessageModel, ResultError>) -> Void)
}

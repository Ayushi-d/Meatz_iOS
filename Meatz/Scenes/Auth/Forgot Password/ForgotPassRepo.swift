//
//  ForgotPassRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/11/21.
//

import Foundation

final class ForgotPassRepo: ForgotPassRepoProtocol {
    func sendPass(_ params: Parameters, _ completion: @escaping (Result<MessageModel, ResultError>) -> Void) {
        AuthApi.forgotPass(params).sendRequst(data: MessageResponse.self) { result in
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

protocol ForgotPassRepoProtocol {
    func sendPass(_ params: Parameters, _ completion: @escaping (_ res: Result<MessageModel, ResultError>) -> Void)
}

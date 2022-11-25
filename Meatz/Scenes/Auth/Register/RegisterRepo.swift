//
//  RegisterRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/8/21.
//

import Foundation

final class RegisterRepo: RegisterRepoProtocol {
    func register(_ params: Parameters, _ completion: @escaping (Result<AuthModel, ResultError>) -> Void) {
        AuthApi.signUp(params).sendRequst(data: LoginResponse.self) { result in
            switch result {
            case .success(let response):
                let model = AuthModel(response)
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

protocol RegisterRepoProtocol: class {
    func register(_ params: Parameters, _ completion: @escaping (_ res: Result<AuthModel, ResultError>) -> Void)
}

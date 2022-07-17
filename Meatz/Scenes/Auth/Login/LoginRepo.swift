//
//  LoginRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/7/21.
//

import Foundation

final class LoginRepo: LoginRepoProtocol {
    func loginWith(_ params: Parameters, _ res: @escaping (Result<AuthModel, ResultError>) -> Void) {
        AuthApi.login(params).sendRequst(data: LoginResponse.self) { [weak self] result in
            guard let self = self else { return }
            self.handleReponse(result, res)
        }
    }

    func socialLogin(_ params: Parameters, _ res: @escaping (Result<AuthModel, ResultError>) -> Void) {
        AuthApi.socialLogin(params).sendRequst(data: LoginResponse.self) { [weak self] result in
            guard let self = self else { return }
            self.handleReponse(result, res)
        }
    }

    fileprivate func handleReponse(_ result: ResultStatuts<LoginResponse>, _ res: @escaping (Result<AuthModel, ResultError>) -> Void) {
        switch result {
        case .success(let response):
            let model = AuthModel(response)
            if model.status {
                res(.success(model))
                //CachingManager.shared.cacheInKeychain(model.user)
                //SHeaders.shared.updateAuthToken(model.user.accessToken)
            } else {
                res(.failure(.messageError(model.message)))
            }
        case .failure(let error):
            res(.failure(error))
        }
    }
}

protocol LoginRepoProtocol {
    func loginWith(_ params: Parameters, _ res: @escaping (_ res: Result<AuthModel, ResultError>) -> Void)
    func socialLogin(_ params: Parameters, _ res: @escaping (_ res: Result<AuthModel, ResultError>) -> Void)
}

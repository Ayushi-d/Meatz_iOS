//
//  ContactUsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import Foundation

final class ContactUsRepo: ContactUsRepoProtocol {
    func contactUs(_ parameters: Parameters, _ completion: @escaping (Result<SuccessModel, ResultError>) -> Void) {
        HomeApi.contactUs(parameters).sendRequst(data: SuccessModel.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol ContactUsRepoProtocol: class {
    func contactUs(_ parameters: Parameters, _ completion: @escaping (_ res: Result<SuccessModel, ResultError>) -> Void)
}

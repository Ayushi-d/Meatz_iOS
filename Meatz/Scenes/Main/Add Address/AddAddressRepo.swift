//
//  AddAddressRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import Foundation

final class AddAddressRepo: AddAddressRepoProtocol {
    func addAddress(_ parameters: Parameters, _ completion: @escaping (Result<MessageModel, ResultError>) -> Void) {
        HomeApi.addAddress(parameters).sendRequst(data: MessageResponse.self) { result in 
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

protocol AddAddressRepoProtocol: class {
    func addAddress(_ parameters: Parameters, _ completion: @escaping (_ res: Result<MessageModel, ResultError>) -> Void)
}

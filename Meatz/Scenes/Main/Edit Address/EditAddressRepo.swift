//
//  EditAddressRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/14/21.
//

import Foundation

final class EditAddressRepo: EditAddressRepoProtocol {
    func editAddress(_ id: Int, _ parameters: Parameters, _ completion: @escaping (Result<MessageModel, ResultError>) -> Void) {
        HomeApi.updateAddress(id, parameters).sendRequst(data: MessageResponse.self) { [weak self] result in
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

protocol EditAddressRepoProtocol: class {
    func editAddress(_ id: Int, _ parameters: Parameters, _ completion: @escaping (_ res: Result<MessageModel, ResultError>) -> Void)
}

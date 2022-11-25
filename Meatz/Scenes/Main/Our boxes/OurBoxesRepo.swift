//
//  OurBoxesRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/1/21.
//

import Foundation

final class OurBoxesRepo: OurBoxesRepoProtocol {
    func getOurBoxes(_ completion: @escaping (Result<OurBoxesModel, ResultError>) -> Void) {
        HomeApi.ourBoxes.sendRequst(data: OurBoxesResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(OurBoxesModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol OurBoxesRepoProtocol: class {
    func getOurBoxes(_ completion: @escaping (_ res: Result<OurBoxesModel, ResultError>) -> Void)
}

//
//  MyBoxesRepo.swift
//  Meatz
//
//  Created by Nabil Elsherbene on 4/14/21.
//

import Foundation

final class MyBoxesRepo: MyBoxesRepoProtocol {
    func didRecieveBoxes(_ completion: @escaping (Result<MyBoxesModel, ResultError>) -> Void) {
        HomeApi.myBoxes.sendRequst(data: MyBoxesResponse.self) { result in
            self.handleReponse(result, completion)
        }
    }

    func deletBox(with id: Int, _ completion: @escaping (Result<MyBoxesModel, ResultError>) -> Void) {
        HomeApi.deleteBox(id).sendRequst(data: MyBoxesResponse.self) { [weak self] result in
            guard let self = self else { return }
            self.handleReponse(result, completion)
        }
    }

    func addToCart(with id: Int, _ completion: @escaping (Result<SuccessModel, ResultError>) -> Void) {
        HomeApi.addBoxToCart(id).sendRequst(data: SuccessModel.self) {  result in
            switch result{
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
           // self.handleReponse(result, completion)
        }
    }

    fileprivate func handleReponse(_ result: ResultStatuts<MyBoxesResponse>, _ completion: @escaping (Result<MyBoxesModel, ResultError>) -> Void) {
        switch result {
        case .success(let response):
            completion(.success(MyBoxesModel(response)))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

protocol MyBoxesRepoProtocol: class {
    func didRecieveBoxes(_ completion: @escaping (_ response: Result<MyBoxesModel, ResultError>) -> Void)
    func deletBox(with id: Int, _ completion: @escaping (_ res: Result<MyBoxesModel, ResultError>) -> Void)
    func addToCart(with id: Int, _ completion: @escaping (_ res: Result<SuccessModel, ResultError>) -> Void)
}

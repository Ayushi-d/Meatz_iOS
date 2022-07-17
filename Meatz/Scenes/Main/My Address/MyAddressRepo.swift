//
//  MyAddressRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import Foundation

final class MyAddressRepo: MyAddressRepoProtocol {}

protocol MyAddressRepoProtocol: class {
    func getAreas(_ completion: @escaping (_ res: Result<AreasModel, ResultError>) -> Void)
    func getAddresses(_ completion: @escaping (_ res: Result<MyAddressModel, ResultError>) -> Void)
    func deleteAddress(with id: Int, _ completion: @escaping (_ res: Result<MyAddressModel, ResultError>) -> Void)
}


extension MyAddressRepoProtocol{
    func getAddresses(_ completion: @escaping (Result<MyAddressModel, ResultError>) -> Void) {
        HomeApi.addresses.sendRequst(data: MyAddressResponse.self) { [weak self] result in
            guard let self = self else { return }
            self.handle(result, completion)
        }
    }

    func deleteAddress(with id: Int, _ completion: @escaping (Result<MyAddressModel, ResultError>) -> Void) {
        HomeApi.deleteAddress(id).sendRequst(data: MyAddressResponse.self) { [weak self] result in
            guard let self = self else { return }
            self.handle(result, completion)
        }
    }

    fileprivate func handle(_ result: ResultStatuts<MyAddressResponse>, _ completion: @escaping (Result<MyAddressModel, ResultError>) -> Void) {
        switch result {
        case .success(let response):
            completion(.success(MyAddressModel(response)))
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func getAreas(_ completion: @escaping (Result<AreasModel, ResultError>) -> Void) {
        HomeApi.areas.sendRequst(data: AreasResponse.self) { result in
            switch result {
            case .success(let response): completion(.success(AreasModel(response)))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

//
//  SettingsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import Foundation

final class SettingsRepo: SettingsRepoProtocol {
    func getSettings(_ completion: @escaping (Result<[SettingsModel]?, ResultError>) -> Void) {
        HomeApi.settings.sendRequst(data: SettingsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data?.map { SettingsModel($0) }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getContactInfo(_ completion: @escaping (Result<ContactInfoModel?, ResultError>) -> Void) {
        HomeApi.contacts.sendRequst(data: ContactInfoResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(ContactInfoModel(response.data!)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol SettingsRepoProtocol: class {
    func getSettings(_ completion: @escaping (_ response: Result<[SettingsModel]?, ResultError>) -> Void)
    func getContactInfo(_ completion: @escaping (_ response: Result<ContactInfoModel?, ResultError>) -> Void)
}

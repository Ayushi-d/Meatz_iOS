//
//  ProfileRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/11/21.
//

import Foundation

final class ProfileRepo: ProfileRepoProtocol {
    
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
    
    func getProfileInfo(_ completion: @escaping (_ res: Result<AuthModel, ResultError>) -> Void) {
        HomeApi.profile.sendRequst(data: LoginResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(AuthModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateProfile(_ params: Parameters, _ completion: @escaping (Result<AuthModel, ResultError>) -> Void) {
        HomeApi.editProfile(params).sendRequst(data: LoginResponse.self) { result in
            switch result {
            case .success(let response):
                let model = AuthModel(response)
                if model.status{
                    completion(.success(model))
                }else{
                    completion(.failure(.messageError(model.message)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout(_ completion: @escaping (Result<SuccessModel, ResultError>) -> Void) {
        HomeApi.logout.sendRequst(data: SuccessModel.self) { result in
            switch result {
            case .success(let response):
                
                if response.status == "success" {
                    completion(.success(response))
                } else {
                    completion(.failure(.messageError(response.message)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol ProfileRepoProtocol {
    func getProfileInfo(_ completion: @escaping (_ res: Result<AuthModel, ResultError>) -> Void)
    func updateProfile(_ params: Parameters, _ completion: @escaping (_ res: Result<AuthModel, ResultError>) -> Void)
    
    func logout(_ completion: @escaping (_ res: Result<SuccessModel, ResultError>) -> Void)
    func getSettings(_ completion: @escaping (_ response: Result<[SettingsModel]?, ResultError>) -> Void)
    func getContactInfo(_ completion: @escaping (_ response: Result<ContactInfoModel?, ResultError>) -> Void)
}

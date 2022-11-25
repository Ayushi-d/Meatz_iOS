//
//  FeaturedRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/30/21.
//

import Foundation

final class FeaturedRepo : FeaturedRepoProtocol{
    func getFeaturedStores(_ completion : @escaping(_ res : Result<FeaturedStoresModel,ResultError>)->Void){
        HomeApi.featured.sendRequst(data: FeaturedStoresResponse.self) { (result) in
            switch result{
            case .success(let response):
                completion(.success(FeaturedStoresModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}


protocol FeaturedRepoProtocol{
    func getFeaturedStores(_ completion : @escaping(_ res : Result<FeaturedStoresModel,ResultError>)->Void)
}

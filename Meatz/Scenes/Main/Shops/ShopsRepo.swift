//
//  ShopsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/28/21.
//

import Foundation

final class ShopsRepo : ShopsRepoProtocol{
    
    func getShops(_ id : Int,_ completion : @escaping(_ response : StoresModel?,_ error : ResultError?) -> Void) {
        HomeApi.shops(id).sendRequst(data: StoresResponse.self) { (result) in
            switch result{
            case .success(let response):
                completion(StoresModel(response),nil)
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
}


protocol ShopsRepoProtocol {
    func getShops(_ id : Int,_ completion : @escaping(_ response : StoresModel?,_ error : ResultError?) -> Void)
}




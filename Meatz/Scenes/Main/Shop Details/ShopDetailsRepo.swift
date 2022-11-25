//
//  ShopDetailsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation

final class ShopDetailsRepo : ShopDetailsRepoProtocol{
    func getShopDetails(_ id: Int, params: Parameters, _ completion: @escaping (Result<ShopDetailsModel, ResultError>) -> Void) {
        HomeApi.shopDetails(id, params).sendRequst(data: ShopDetailsResponse.self) { (result) in
            switch result{
            case .success(let response):
                completion(.success(ShopDetailsModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


protocol ShopDetailsRepoProtocol : class{
    func getShopDetails(_ id : Int,params : Parameters,_ completion : @escaping(_ result : Result<ShopDetailsModel,ResultError>)->Void)
}



protocol Parameters {
    var body : [ String : Any]{get}
}

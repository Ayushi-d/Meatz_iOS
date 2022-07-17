//
//  WhishlistRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/12/21.
//

import Foundation

final class WhishlistRepo: WhishlistRepoProtocol {
    func getWhishList(_ page: Int, _ completion: @escaping (Result<WishlistModel, ResultError>) -> Void) {
        HomeApi.whishList(page).sendRequst(data: WishlistResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(WishlistModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol WhishlistRepoProtocol: class {
    func getWhishList(_ page: Int, _ completion: @escaping (_ res: Result<WishlistModel, ResultError>) -> Void)
    func likeDisLike(_ id : Int ,completion: @escaping (_ res: Result<LikeModel, ResultError>)-> Void)
}

extension WhishlistRepoProtocol {
    func getWhishList(_ page: Int, _ completion: @escaping (_ res: Result<WishlistModel, ResultError>) -> Void){}
    
    func likeDisLike(_ id: Int, completion: @escaping (Result<LikeModel, ResultError>) -> Void) {
        HomeApi.productLike(id).sendRequst(data: LikeResponse.self) { (result) in
            switch result{
            case .success(let response):
                completion(.success(LikeModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

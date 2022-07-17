//
//  OfferDetailsRepo.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/20/21.
//

import Foundation

protocol OfferDetailsRepoProtocol {
    func getOffersData(offerId: Int ,_ completion: @escaping (_ result: Result<OfferDetailsModel, ResultError>) -> Void)
    
    func addToCart(_ params: Parameters, _ completion: @escaping (Result<MessageModel, ResultError>) -> Void)
}

class OfferDetailsRepo: OfferDetailsRepoProtocol {
    func getOffersData(offerId: Int, _ completion: @escaping (Result<OfferDetailsModel, ResultError>) -> Void) {
        
        HomeApi.offerDetails(offerId).sendRequst(data: OfferDetailsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(OfferDetailsModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func addToCart(_ params: Parameters, _ completion: @escaping (Result<MessageModel, ResultError>) -> Void) {
        HomeApi.addToCart(params).sendRequst(data: MessageResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(MessageModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    

}

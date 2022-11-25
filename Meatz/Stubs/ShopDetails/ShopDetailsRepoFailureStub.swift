//
//  ShopDetailsRepoFailureStub.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation

final class ShopDetailsRepoFailureStub: ShopDetailsRepoProtocol {
    func getShopDetails(_ id: Int, params: Parameters, _ completion: @escaping (Result<ShopDetailsModel, ResultError>) -> Void) {
        completion(.failure(.messageError("message for test")))
    }
}

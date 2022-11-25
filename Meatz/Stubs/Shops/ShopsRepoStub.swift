//
//  ShopsRepoStub.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/28/21.
//

import Foundation

/// Shops success stub
final class ShopsRepoStub: ShopsRepoProtocol {
    func getShops(_ id : Int,_ completion: @escaping (StoresModel?, ResultError?) -> Void) {
        let shops = [StoreModel(id: 1, image: "firstImage", name: "First Shop", mobile: "", banner: "", rating: "", tags: []),
                     StoreModel(id: 2, image: "secondImage", name: "Second Shop", mobile: "", banner: "", rating: "", tags: [])]
        completion(StoresModel(shops, []), nil)
    }
}

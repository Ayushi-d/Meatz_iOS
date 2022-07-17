//
//  ShopDetailsRepoStub.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation

final class ShopDetailsRepoStub: ShopDetailsRepoProtocol {
    func getShopDetails(_ id: Int, params: Parameters, _ completion: @escaping (Result<ShopDetailsModel, ResultError>) -> Void) {
        let products = [Product(id: 22,
                                name: "First Product",
                                price: "200.222",
                                priceBefore: "12",
                                image: "", type: .product),
                        Product(id: 23,
                                name: "Second Product",
                                price: "500.222",
                                priceBefore: "123",
                                image: "", type: .product),
                        Product(id: 24,
                                name: "third Product",
                                price: "500.222",
                                priceBefore: "12",
                                image: "", type: .product),
                        Product(id: 25,
                                name: "fourth Product",
                                price: "500.222",
                                priceBefore: "10",
                                image: "", type: .product),
                        Product(id: 26,
                                name: "fifth Product",
                                price: "500.222",
                                priceBefore: "13",
                                image: "", type: .product),
                        Product(id: 27,
                                name: "6th Product",
                                price: "500.222",
                                priceBefore: "90",
                                image: "", type: .product),
                        Product(id: 28,
                                name: "7th Product",
                                price: "500.222",
                                priceBefore: "20",
                                image: "", type: .product),
                        Product(id: 29,
                                name: "8th Product",
                                price: "500.222",
                                priceBefore: "30",
                                image: "", type: .product)
        ]
        let store = StoreDetails(id: 1,
                                 name: "Test shop",
                                 logo: "link",
                                 color: "",
                                 productsCount: 2,
                                 products: products)
        let data = ShopDetailsData(store: store, cart: nil, ads: [
            Ad(id: 100, status: 1, sort: 1, title: "firstAd", model: "box", modelID: 2, image: "first ad image link"),
            Ad(id: 200, status: 2, sort: 1, title: "secondAd", model: "product", modelID: 3, image: "second ad image link")
        ], categories: [])
        
        let res = ShopDetailsResponse(status: "success", message: "", data: data)
        let model = ShopDetailsModel(res)
        completion(.success(model))
    }
}

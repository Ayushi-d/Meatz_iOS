//
//  HomeRepoFailureStub.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/1/21.
//

import Foundation

final class HomeRepoFailureStub : HomeRepoProtocol{
    func getHomeData(_ completion: @escaping (Result<HomeModel, ResultError>) -> Void) {
        completion(.failure(.messageError("Home request failure")))
    }
}

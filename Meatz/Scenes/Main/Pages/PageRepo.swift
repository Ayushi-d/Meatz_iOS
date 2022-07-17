//
//  PageRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import Foundation

final class PageRepo: PageRepoProtocol {
    func getPage(with id: Int, _ completion: @escaping (Result<PageModel?, ResultError>) -> Void) {
        HomeApi.page(id).sendRequst(data: PageResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(PageModel(response.data!)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol PageRepoProtocol: class {
    func getPage(with id: Int, _ completion: @escaping (_ result: Result<PageModel?, ResultError>) -> Void)
}

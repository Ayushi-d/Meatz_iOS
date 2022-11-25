//
//  NotificationsRepo.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import Foundation

final class NotificationsRepo: NotificationsRepoProtocol {
    func getNotifications(_ completion: @escaping (Result<NotificationsModel, ResultError>) -> Void) {
        HomeApi.notifications.sendRequst(data: NotificationsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(NotificationsModel(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

protocol NotificationsRepoProtocol: class {
    func getNotifications(_ completion: @escaping (_ result: Result<NotificationsModel, ResultError>) -> Void)
}

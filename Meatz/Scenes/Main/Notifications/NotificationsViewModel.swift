//
//  NotificationsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import Foundation

final class NotificationsViewModel {
    var state: State = .notStarted
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable.init(nil)
    private var repo : NotificationsRepoProtocol?
    private var coordinator : Coordinator?
    private var notifications : [NotificationModel] = []
    init(_ repo : NotificationsRepoProtocol?,_ coordinator : Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension NotificationsViewModel : NotificationsVMProtocol{
    var numberOfNotifications: Int{
        return notifications.count
    }
    func onViewDidLoad() {
        repo?.getNotifications({ [weak self](result) in
            guard let self = self else{return}
            switch result{
            case .success(let model):
                self.state = .notStarted
                self.notifications = model.notifications
                guard let completion = self.onRequestCompletion else{return}
                completion("")
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
    func didSelectNotificaiton(at index: Int) {
        let notification = notifications[index]
        let type = notification.type
        guard notification.ID > 0 else{return}
        if type == .order{
            coordinator?.navigateTo(MainDestination.orderDetails(notification.itemID))
        }else{
           // coordinator?.navigateTo(MainDestination.product(notification.itemID))
        }
    }
    
    func viewModelForCell(at index: Int) -> NotificationCellViewModel {
        return notifications[index]
    }
}


protocol NotificationsVMProtocol : ViewModel{
    var numberOfNotifications : Int{get}
    func onViewDidLoad()
    func didSelectNotificaiton(at index : Int)
    func viewModelForCell(at index : Int) -> NotificationCellViewModel
}


protocol NotificationCellViewModel {
    var ID: Int{get}
    var notificationContent : String {get}
    var type: NotificationItemType{get}
    var itemID : Int {get}
    var notificationImage : String{get}
    var date : String{get}
}

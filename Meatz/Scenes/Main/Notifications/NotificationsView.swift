//
//  NotificationsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import UIKit

final class NotificationsView: MainView {
    @IBOutlet private weak var tableView: UITableView?
    var viewModel : NotificationsVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        onError()
        onCompletion()
        showLoading()
        viewModel.onViewDidLoad()
    }
    
    
    fileprivate func onError(){
        viewModel.requestError?.binding = {[weak self] error  in
            guard let self = self , let err = error else{return}
            self.hideLoading()
            self.showToast("", err.describtionError, completion: nil)
        }
    }
    
    fileprivate func onCompletion(){
        viewModel.onRequestCompletion = {[weak self] text in
            guard let self = self else{return}
            self.hideLoading()
            let isEmpty = self.viewModel.numberOfNotifications == 0
            self.messageView(R.string.localizable.thereAreNoNotifications(),
                             R.image.listEmpty(), hide: !isEmpty)
            self.tableView?.reloadData()
        }
    }

}

extension NotificationsView : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfNotifications
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NotificationCell.self, indexPath: indexPath)
        cell.viewModel = viewModel.viewModelForCell(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectNotificaiton(at: indexPath.row)
    }
}

// MARK:- Loading
extension NotificationsView {
    func showLoading(){
        startShimmerAnimation()
        tableView?.startShimmerAnimation(withIdentifier: NotificationCell.identifier)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        tableView?.stopShimmerAnimation()
    }
}

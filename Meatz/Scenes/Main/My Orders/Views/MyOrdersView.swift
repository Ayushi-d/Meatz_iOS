//
//  MyOrdersView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/15/21.
//

import UIKit

final class MyOrdersView: MainView {
    @IBOutlet private weak var tableView: UITableView?
    var viewModel : MyOrdersVMProtocol!
    
    private var isSkeleton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNavigationItems(cartEnabled: false)
        onError()
        onCompletion()
        if isSkeleton == false {
            isSkeleton = true
            showLoading()
        }

        viewModel.onViewDidLoad()
        checkOnStateView()
    }
    
    fileprivate func checkOnStateView(){
        if viewModel.pushedFromOrderState{
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationItem.rightBarButtonItem = homeButton
        }
    }
    

    fileprivate func onCompletion(){
        viewModel.onRequestCompletion = {[weak self] _ in
            guard let self = self else{return}
            self.hideLoading()
            let isEmpty = self.viewModel?.numberOfOrders == 0
            self.messageView(R.string.localizable.noOrders(),
                             R.image.listEmpty(),
                             hide: !isEmpty)
            self.tableView?.reloadData()
        }
    }
    
    fileprivate func onError(){
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self ,let error_ = error else{return}
            self.hideLoading()
            self.showToast("", error_.describtionError, completion: nil)
        }
    }
}

//MARK:- My Orders
extension MyOrdersView : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfOrders
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MyOrdersCell.self, indexPath: indexPath)
        cell.viewModel = viewModel.viewModelForOrder(at: indexPath.row)
        cell.delegate = viewModel
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectOrder(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }
}

// MARK:- Loading
extension MyOrdersView {
    func showLoading(){
        startShimmerAnimation()
        tableView?.startShimmerAnimation(withIdentifier: MyOrdersCell.identifier)
 
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        tableView?.stopShimmerAnimation()
    }
}


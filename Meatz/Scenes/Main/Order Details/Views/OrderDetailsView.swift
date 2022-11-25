//
//  OrderDetailsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/16/21.
//

import UIKit

final class OrderDetailsView: MainView {
    @IBOutlet private weak var orderIDLabel: MediumLabel?
    @IBOutlet private weak var orderDateLabel: MediumLabel?
    @IBOutlet private weak var paymentIDLabel: MediumLabel?
    @IBOutlet private weak var transactionIDLabel: MediumLabel?
    @IBOutlet private weak var addressLabel: MediumLabel?
    @IBOutlet private weak var statusView: UIView?
    @IBOutlet private weak var statusLabel: MediumLabel?
    @IBOutlet private weak var totalLabel: MediumLabel?
    @IBOutlet private weak var discountLabel: BaseLabel?
    @IBOutlet private weak var deliveryChargeLabel: BaseLabel?
    @IBOutlet private weak var productsTotalLabel: BaseLabel?
    @IBOutlet private weak var paymentMethodLabel: BaseLabel?
    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var reorderView: UIView?
    
    @IBOutlet private weak var deliveryTypeLabel: MediumLabel!
    @IBOutlet private weak var deliveryDateLabel: MediumLabel!
    @IBOutlet private weak var deliveryTimeLabel: MediumLabel!
    @IBOutlet private weak var cancelOrderButton: UIButton?
    
    
    
    var viewModel : OrderDetailsVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
        addNavigationItems(cartEnabled: false)
        statusView?.isHidden = true
        onError()
        onCompletion()
        showLoading()
        viewModel.onViewDidLoad()
        tableView?.isScrollEnabled = false
    }

    fileprivate func onError(){
        viewModel.requestError?.binding = {[weak self] error in
            guard let self = self , let err = error else{return}
            self.hideLoading()
            self.showToast("", err.describtionError, completion: nil)
        }
    }
    
    fileprivate func onCompletion(){
        viewModel.orderInfo.binding = {[weak self] model in
            guard let self = self , let order = model else{return}
            self.paymentIDLabel?.text = order.paymentInfo.paymentID
            self.paymentMethodLabel?.text = order.paymentInfo.paymentMethod
            self.transactionIDLabel?.text = order.paymentInfo.transactionID
            self.totalLabel?.text = order.paymentInfo.total + " " + R.string.localizable.kwd()
            self.orderDateLabel?.text = order.createdAt
            self.orderIDLabel?.text = "#" + order.id.toString
            self.statusLabel?.text = order.status
            self.productsTotalLabel?.text = order.paymentInfo.subtotal
            self.deliveryChargeLabel?.text = order.paymentInfo.delivery
            if CachingManager.shared.isLogin {
                self.addressLabel?.text = order.address.orderDetailsAddress
            } else {
                self.addressLabel?.text = self.viewModel.guestAddress
            }
           
            self.discountLabel?.text =  order.paymentInfo.discount
            if order.isCashPayment{
                self.paymentIDLabel?.text = R.string.localizable.nA()
                self.transactionIDLabel?.text = R.string.localizable.nA()
            }
            self.reorderView?.isHidden = !order.canReorder
            
            self.cancelOrderButton?.isHidden = !order.canCancel
            self.deliveryTypeLabel.text = order.delivery.deliveryType
            self.deliveryDateLabel.text = order.delivery.date
            self.deliveryTimeLabel.text = order.delivery.time
            self.setUpStatusViewCorners()
            self.statusView?.isHidden = false
            self.tableView?.isScrollEnabled = true
        }
        viewModel.onRequestCompletion = {[weak self] _ in
            guard let self = self else{return}
            self.hideLoading()
            self.tableView?.reloadData()
        }
        
        viewModel.showCancelDialog.binding = { [weak self] message in
            guard let self = self else{return}
            self.showDialogue(R.string.localizable.requestSent(), message ?? "", R.string.localizable.ok()) { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    fileprivate func setUpStatusViewCorners(){
        if MOLHLanguage.isArabic() {
            statusView?.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        }else {
            statusView?.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]

        }
    }
    
    @IBAction func reorder(_ sender : UIButton){
        showActivityIndicator()
        viewModel.reorder()
    }
    
    @IBAction func cancelOrder(_ sender : UIButton){
        showActivityIndicator()
        viewModel.cancelOrder()
    }
}


//MARK:- TableView
extension OrderDetailsView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.viewModelForCell(at: indexPath.row)
        switch item.ItemType{
        case .box, .specialBox:
            let cell = tableView.dequeue(OrderBoxCell.self, indexPath: indexPath)
            cell.viewModel = item
            return cell
        case .product:
            let cell = tableView.dequeue(OrderProductCell.self, indexPath: indexPath)
            cell.viewModel = item
            return cell
        case .null:
            return UITableViewCell()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.viewModelForCell(at: indexPath.row)
        if item.ItemType == .product{
            return 182
        }else{
            return 120
        }
    }
}

// MARK:- Loading
extension OrderDetailsView {
    func showLoading(){
        startShimmerAnimation()
        tableView?.startShimmerAnimation(withIdentifier: OrderBoxCell.identifier)
 
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        tableView?.stopShimmerAnimation()
        hideActivityIndicator()
    }
}

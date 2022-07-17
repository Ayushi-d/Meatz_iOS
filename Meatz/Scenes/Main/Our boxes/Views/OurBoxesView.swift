//
//  OurBoxesView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/1/21.
//

import UIKit

final class OurBoxesView: MainView {

    @IBOutlet private weak var cartCountLabel: BaseLabel?
    @IBOutlet private weak var cartTotalLabel: BaseLabel?
    @IBOutlet private weak var cartView: UIView?
    @IBOutlet private weak var countLabel: BaseLabel?
    @IBOutlet private weak var tableView : UITableView?
    @IBOutlet private weak var viewVartHConstraint: NSLayoutConstraint!
    
    var viewModel : OurBoxesVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        onError()
        onCompletion()
        showLoading()
        viewModel.onViewDidLoad()
    }
    
    fileprivate func onError(){
        viewModel.requestError?.binding = {[weak self] error in
            guard let self = self else{return}
            guard let err = error else{return}
            self.showError(err)
            self.hideLoading()
        }
    }
    fileprivate func onCompletion(){
        viewModel.onRequestCompletion = {[weak self] _ in
            guard let self = self else{return}
            self.loadData()
            self.tableView?.reloadData()
            self.hideLoading()
        }
    }

    fileprivate func loadData(){
        cartCountLabel?.text = viewModel.cartCount
        cartView?.isHidden = viewModel.shouldHideCartView
        viewVartHConstraint.constant = viewModel.shouldHideCartView ? 0 : 56
        cartTotalLabel?.text = viewModel.cartAmount
        countLabel?.text = viewModel.availableBoxesCount
    }
    
}

//MARK:- Actions
extension OurBoxesView {
    @IBAction private func viewCart(_ sender : UIButton){
        viewModel.viewCart()
    }
}
//MARK:- TableView
extension OurBoxesView : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfBoxes
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(OurBoxesCell.self, indexPath: indexPath)
        cell.viewModel = viewModel.viewModelForCell(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectBox(at: indexPath.row)
    }
}

// MARK:- Loading
extension OurBoxesView {
    func showLoading(){
        startShimmerAnimation()
        tableView?.startShimmerAnimation(withIdentifier: OurBoxesCell.identifier, numberOfRows: 6, numberOfSections: 1)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        tableView?.stopShimmerAnimation()
    }
}

//
//  MyAddressView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import UIKit

final class MyAddressView: MainView {
    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var addressesCountLabel: BaseLabel?
    @IBOutlet weak var noAddressImage: UIImageView!
    
    var viewModel : MyAddressVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noAddressImage.image = #imageLiteral(resourceName: "No Address").imageFlippedForRightToLeftLayoutDirection()
        addNavigationItems(cartEnabled: false)
        onError()
        onCompletion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        viewModel.onViewDidLoad()
    }
    fileprivate func onError(){
        viewModel.requestError?.binding = {[weak self] error in
            guard let self = self ,let err = error else{return}
            self.hideLoading()
            self.showToast("", err.describtionError, completion: nil)
        }
    }
    fileprivate func onCompletion(){
        viewModel.onRequestCompletion = {[weak self] _ in
            guard let self = self else{return}
            self.hideLoading()
            self.tableView?.isHidden = self.viewModel.numberOfAddresses == 0
            self.addressesCountLabel?.text = self.viewModel.saveAddressesString
            self.tableView?.reloadData()
        }
    }
}

//MARK:- Actions
extension MyAddressView {
    @IBAction func addNewAddress(_ sender : UIButton){
        viewModel.addAddress()
    }
}
//MARK:- UITableView
extension MyAddressView : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfAddresses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MyAddressCell.self, indexPath: indexPath)
        cell.viewModel = viewModel.viewModelForAddress(at: indexPath.row)
        cell.onEditing = { [unowned self] vm in
            self.viewModel.edit(vm)
        }
        cell.onDeleting = {[unowned self] vm in
            self.showDialogue(R.string.localizable.deleteAddress(),
                              R.string.localizable.addressRemovalMessage(),
                              R.string.localizable.ok()) {[weak self] in
                guard let self = self else{return}
                self.showActivityIndicator()
                self.viewModel.deleteAddress(with: vm.ItemID)
            }
        }
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectAddress(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }

}

// MARK:- Loading
extension MyAddressView {
    func showLoading(){
        startShimmerAnimation()
        tableView?.startShimmerAnimation(withIdentifier: MyAddressCell.identifier)
 
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        tableView?.stopShimmerAnimation()
    }
}

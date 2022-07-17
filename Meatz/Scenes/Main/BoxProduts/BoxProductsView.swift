//
//  BoxProductsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/14/21.
//

import UIKit

final class BoxProductsView: MainView {
    // MARK: - Outlets

    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var boxNameLbl: BaseLabel!
    @IBOutlet weak var updatebutton: BoldButton!
    
    // MARK: - ViewModel

    var viewModel: BoxProductsVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        setupTableView()
        onError()
        onCompletion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        viewModel.viewDidLoad()
    }

    @IBAction func updateButton(_ sender: Any) {
        showActivityIndicator()
        viewModel.deleteItem()
    }
}

// MARK: - Update UI

private extension BoxProductsView {
    func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.hideLoading()
            self.showToast("", err.describtionError, completion: nil)
        }
    }

    func onCompletion() {
        viewModel.onRequestCompletion = {[weak self] _ in
            guard let self = self else{return}
            self.productsTableView.reloadData()
            let isEmpty = self.viewModel.numberOfProducts == 0
            self.messageView(R.string.localizable.thereIsNoItemsInBoxAddItems(),
                             R.image.boxesWarning(), hide: !isEmpty)
        }
        
        viewModel.isThereItemsDeleted.binding = {[weak self] _ in
            guard let self = self else{return}
            self.updatebutton.isHidden = false
        }
        viewModel.model.binding = { [weak self] data in
            guard let self = self else { return }
            self.hideLoading()
            self.boxNameLbl.text = data?.header.boxName
            self.productsTableView?.reloadData()
            guard !data!.message.isEmpty else { return }
            self.showToast("", data?.message ?? "", completion: nil)
        }
    }
}

// MARK: - TabeView Adapter

extension BoxProductsView: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        productsTableView.delegate = self
        productsTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(BoxProductsViewCell.self, indexPath: indexPath)
        cell.model = viewModel.dequeCellForRow(at: indexPath)
        cell.delegate = viewModel as? DeleteItemProtocol
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }
}


// MARK:- Loading
extension BoxProductsView {
    func showLoading(){
        startShimmerAnimation()
        productsTableView?.startShimmerAnimation(withIdentifier: BoxProductsViewCell.identifier)
 
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        productsTableView?.stopShimmerAnimation()
        hideActivityIndicator()
    }
}

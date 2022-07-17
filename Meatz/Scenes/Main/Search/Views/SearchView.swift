//
//  SearchView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/4/21.
//

import UIKit

final class SearchView: MainView {
    @IBOutlet private var searchTextField: BaseTextField?
    @IBOutlet private var tableView: UITableView?
    var viewModel: SearchVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeSearchField()
        addNavigationItems(cartEnabled: false)
        showLoading()
        onError()
        onCompletion()
        viewModel.search(key: "") /// first we get all the data
    }
    
    fileprivate func observeSearchField() {
        searchTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.search(key: text ?? "")
        }
    }
    
    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            if let self = self, let err = error {
                self.showError(err)
                self.hideLoading()
            }
        }
    }
    
    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.tableView?.reloadData()
            self.hideLoading()
            self.messageView(R.string.localizable.noResultFound(),
                             R.image.notFound()?.imageFlippedForRightToLeftLayoutDirection(),
                             hide: !(self.viewModel.isItemsEmpty && self.viewModel.isStoresEmpty))
        }
    }
}

// MARK: - TableView

extension SearchView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let count = viewModel.numberOfStores
            return count > 3 ? 3 : count
        }
        let itemsCount = viewModel.numberOfItems
        return itemsCount > 3 ? 3 : itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeue(SearchStoreCell.self, indexPath: indexPath)
            cell.viewModel = viewModel.viewModelForStore(at: indexPath.row)
            return cell
        }
        let cell = tableView.dequeue(SearchItemCell.self, indexPath: indexPath)
        cell.viewModel = viewModel.viewModelForeItem(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.didSelectStore(at: indexPath.row)
        } else {
            viewModel.didSelectItem(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0, viewModel.isStoresEmpty { return nil }
        if section == 1, viewModel.isItemsEmpty { return nil }
        
        let headerTitleLabel = MediumLabel()
        headerTitleLabel.fontSize = 20
        headerTitleLabel.textColor = R.color.meatzBlack()
        headerTitleLabel.text = viewModel.titleForSection(section)
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.backgroundColor = R.color.meatzBg()
        headerView.addSubview(headerTitleLabel)
        
        NSLayoutConstraint.activate([
            headerTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headerTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0, viewModel.numberOfStores > 3 {
            return headerButton(section)
        }
        if section == 1, viewModel.numberOfItems > 3 {
            return headerButton(section)
        }
        return nil
    }
    
    fileprivate func headerButton(_ section: Int) -> MediumButton {
        let button = MediumButton()
        let topLayer = CALayer()
        topLayer.borderColor = #colorLiteral(red: 0.737254902, green: 0.737254902, blue: 0.737254902, alpha: 1).cgColor
        topLayer.borderWidth = 1
        topLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1)
        button.layer.addSublayer(topLayer)
        
        button.fontSize = 16
        button.setTitleColor(R.color.meatzRed(), for: .normal)
        button.setTitle(R.string.localizable.seeMore(), for: .normal)
        button.tag = section
        button.alignmentEnabled = false
        button.addTarget(self, action: #selector(seeMorePressed(_:)), for: .touchUpInside)
        return button
    }
    
    @objc fileprivate func seeMorePressed(_ sender: MediumButton) {
        let section = sender.tag
        if section == 0 {
            viewModel.seeMoreStores()
        } else {
            viewModel.seeMoreItems()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return viewModel.numberOfStores < 4 ? 0 : 50
        }
        return viewModel.numberOfItems < 4 ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return viewModel.isStoresEmpty ? 0 : 50
        }
        return viewModel.isItemsEmpty ? 0 : 50
    }
}


// MARK:- Loading
extension SearchView {
    func showLoading(){
        startShimmerAnimation()
        tableView?.startShimmerAnimation(withIdentifier: SearchItemCell.identifier)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        tableView?.stopShimmerAnimation()
    }
}

//
//  OffersView.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/19/21.
//

import UIKit

class OffersView: MainView {
    
    @IBOutlet private weak var searchTextField: BaseTextField!
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var numberOfResultsLabel: MediumLabel!
    @IBOutlet private weak var resultFoundView: UIStackView!
    @IBOutlet private weak var offersTableView: UITableView!
    
    
    var viewModel: OffersVMProtcol!

    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorStatus()
        setupCollection()
        setupTableView()
        observeRequestCompletion()
        observeRequestError()
        handleSearchTextField()
        showLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationItems(true)
        resultFoundView.isHidden = true
        searchTextField.text = ""
        viewModel.updateParameters(type: .id(0))
        viewModel.updateParameters(type: .key(""))
        viewModel.viewOnDidLoad()
    }
    
    override func notificationPressed() {
        viewModel.goToNotification()
    }
    
    fileprivate func indicatorStatus() {
        viewModel.showActivityIndicator.binding = { [weak self] status in
            guard let self = self else { return }
            switch status {
            case true:
                self.showActivityIndicator()
            case false:
                self.hideLoading()
            default: break
            }
        }
    }
    
    fileprivate func observeRequestCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.categoryCollectionView?.reloadData()
            
            self.offersTableView?.reloadData()
            if self.viewModel.numberOfOffers == 0 {
                self.offersTableView.emptyMessage(message: self.viewModel.isSearched ?
                    R.string.localizable.noOffersFound():
                    R.string.localizable.noResultFound(), image: R.image.notFound(), details: nil)
            } else {
                self.offersTableView.emptyMessage(message: "", image: nil, details: nil)
            }
            self.hideLoading()
            self.resultFoundView.isHidden = self.viewModel.isSearched
            self.numberOfResultsLabel.text = self.viewModel.numberOfOffers.toString
        }

    }

    fileprivate func observeRequestError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            guard let err = error else { return }
            self.showError(err)
            self.hideLoading()
        }
    }
    
    fileprivate func handleSearchTextField() {
        searchTextField.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.handelSearchKey(text: text ?? "")
        }
    }
}

extension OffersView {
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        showActivityIndicator()
        viewModel.search()
    }
}


extension OffersView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private func setupCollection() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCategories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath, type: OffersCategoryCell.self)
        cell.model = viewModel.getCategoryModel(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 60) / 3
        
        return CGSize(width: width, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCategory(at: indexPath.item)
    }

}


extension OffersView: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        offersTableView.dataSource = self
        offersTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfOffers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(OfferTableViewCell.self, indexPath: indexPath)
        cell.model = viewModel.getOfferModel(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didselectOfferItem(at: indexPath.row)
    }
}

extension OffersView {
    private func showLoading(){
        startShimmerAnimation()
        
        categoryCollectionView?.startShimmerAnimation(withIdentifier: OffersCategoryCell.identifier)
        
        offersTableView?.startShimmerAnimation(withIdentifier: OfferTableViewCell.identifier)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        
        categoryCollectionView?.stopShimmerAnimation()
        
        offersTableView?.stopShimmerAnimation()
        self.hideActivityIndicator()
    }
}

//
//  WalletView.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/22/21.
//

import UIKit

class WalletView: MainView {
    
    @IBOutlet weak var balanceAmountLabel: BoldLabel!
    @IBOutlet weak var rechargeAmountTextField: BaseTextField!
    @IBOutlet weak var currencyTitleLabel: BaseLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: WalletRepoVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleLogo
        observeRequestCompletion()
        observeRequestError()
        setupList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showLoading()
        viewModel.onViewDidLoad()
    }
    
    fileprivate func observeRequestCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.hideLoading()
            self.balanceAmountLabel.text = self.viewModel.balance  + " " + R.string.localizable.kwd()
            self.collectionView.reloadData()
            self.rechargeAmountTextField.text = ""
        }
    }
    
    fileprivate func observeRequestError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            guard let err = error else { return }
            self.showError(err)
            self.hideLoading()
            self.rechargeAmountTextField.text = ""
        }
        
        viewModel.message.binding = { [weak self] message in
            guard let self = self else { return }
            self.hideLoading()
            self.showToast("", message ?? "", completion: nil)
            self.rechargeAmountTextField.text = ""
        }
        
        viewModel.showIndocator.binding = { [weak self] stauts in
            guard let self = self else { return }
            if stauts ?? true {
                self.showActivityIndicator()
            } else {
                self.hideLoading()
            }
        }
    }
    
    @IBAction func rechargeButtonTapped(_ sender: UIButton) {
        viewModel.rechargeAmount(amount: rechargeAmountTextField.text ?? "")
    }
    
}

extension WalletView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private func setupList() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfPackages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath, type: WalletCollectionViewCell.self)
        cell.model = viewModel.getPackageModel(at: indexPath.item)
        cell.rechargeAction = { [weak self] in
            guard let self = self else { return }
            self.viewModel.rechargePackage(at: indexPath.item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( collectionView.frame.width / 2 ) - 10
        return CGSize(width: width, height: 145)
    }
    
    
}


// MARK:- Loading
extension WalletView {
    func showLoading(){
        startShimmerAnimation()

        collectionView.startShimmerAnimation(withIdentifier: WalletCollectionViewCell.identifier, numberOfRows: 0, numberOfSections: 0)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        hideActivityIndicator()
        collectionView?.stopShimmerAnimation()
    }
}

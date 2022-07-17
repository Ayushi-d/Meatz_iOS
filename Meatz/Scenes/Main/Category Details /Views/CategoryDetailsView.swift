//
//  CategoryDetailsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/31/21.
//

import UIKit

final class CategoryDetailsView: MainView {
    @IBOutlet private weak var cartCountLabel: BaseLabel?
    @IBOutlet private weak var cartTotalLabel: BaseLabel?
    @IBOutlet private weak var cartView: UIView?
    @IBOutlet private var shopCountLabel: BaseLabel?
    @IBOutlet private var categoryNameLabel: BaseLabel?
    @IBOutlet private var categoryLogoImageView: UIImageView?
    @IBOutlet private var collectionView: UICollectionView?
    var viewModel: CategoryDetailsVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems()
        onError()
        onCompletion()
       showLoading()
        viewModel.onViewDidLoad()
    }

    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            guard let err = error else { return }
            self.hideLoading()
            self.showError(err)
        }
    }

    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] message in
            guard let self = self else { return }
            self.hideLoading()
            self.messageView(R.string.localizable.thereAreNoShops(),
                             R.image.listEmpty(),
                             hide: !self.viewModel.isShopsEmpty)
            self.collectionView?.reloadData()
            self.loadData()
        }
    }

    fileprivate func loadData() {
        categoryNameLabel?.text = viewModel.categoryName
        categoryLogoImageView?.loadImage(viewModel.categoryLogo)
        shopCountLabel?.text = viewModel.shopsCountString
        cartView?.isHidden = viewModel.isCartEmpty
        cartCountLabel?.text = viewModel.cartCount.toString
        cartTotalLabel?.text = viewModel.cartTotal
    }
    
    deinit {
        print("category details is released ..")
    }
}

// MARK: - CollectionView

extension CategoryDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfShops
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.shopForItem(at: indexPath.item)
        let type = item.type
        if type == .product {
            let cell = collectionView.dequeue(indexPath: indexPath, type: ShopCell.self)
            cell.viewModel = item
            return cell
        }
        let cell = collectionView.dequeue(indexPath: indexPath, type: BannerCell.self)
        cell.viewModel = item
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let type = viewModel.shopForItem(at: indexPath.item).type
        guard type == .product else {
            return CGSize(width: collectionView.frame.width - 40, height: 125)
        }
        let width = view.frame.width / 1.1
        let height = (self.collectionView?.frame.height)!/2.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectShop(at: indexPath.item)
    }
}


//MARK:- Actions
extension CategoryDetailsView {
    @IBAction func viewCartAction(_ sender : UIButton){
        viewModel.viewCart()
    }
}


// MARK:- Loading
extension CategoryDetailsView {
    func showLoading(){
        startShimmerAnimation()
        collectionView?.startShimmerAnimation(withIdentifier: BannerCell.identifier)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        collectionView?.stopShimmerAnimation()
    }
}

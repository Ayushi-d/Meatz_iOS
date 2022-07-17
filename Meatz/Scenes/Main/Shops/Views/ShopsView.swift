//
//  ShopsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import UIKit

final class ShopsView: MainView {
    @IBOutlet private var categoriesCollectionView: UICollectionView?
    @IBOutlet private var shopsCollectionView: UICollectionView?

    var viewModel: ShopsViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpShopsCollectionLayout()
        setUpCategoryCollectionLayout()
        showLoading()
        observeError()
        handleState()
        viewModel?.onViewDidLoad()
    }

    fileprivate func handleState() {
        viewModel?.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            guard let state_ = self.viewModel?.state else { return }
            switch state_ {
            case .finishWithError(let error):
                print(error.describtionError)
            case .success:
                self.checkEmptyCase()
                self.shopsCollectionView?.reloadData()
                self.categoriesCollectionView?.reloadData()
            default: break
            }
            self.stopShimmerAnimation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationItems(true)
    }

    fileprivate func observeError() {
        viewModel?.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            if let err = error {
                self.showError(err)
                self.stopShimmerAnimation()
            }
        }
    }
    
    fileprivate func checkEmptyCase(){
       let shopsCount = self.viewModel?.numberOfShops ?? 0
       messageView(R.string.localizable.thereAreNoShops(),
                   R.image.listEmpty(),hide: shopsCount != 0)
        
    }
    
    override func notificationPressed() {
        viewModel?.goToNotification()
    }
}

// MARK: - UICollectionView Delegate ,DataSouce

extension ShopsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return 3
        }
        return viewModel?.numberOfShops ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeue(indexPath: indexPath, type: ShopCategoryCell.self)
            cell.viewModel = viewModel?.categoryForItem(at: indexPath.item)
            return cell
        }
        let cell = collectionView.dequeue(indexPath: indexPath, type: ShopCell.self)
        cell.viewModel = viewModel?.shopForItem(at: indexPath.item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            showActivityIndicator()
            viewModel?.selectCategory(at: indexPath.item)
        }else{
            viewModel?.selectShop(at: indexPath.item)
        }
    }
}

// MARK: - UICollectionViewFlowLayouts

extension ShopsView {
    fileprivate func setUpCategoryCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        let width = (view.frame.width - 60) / 3
        let height = width
        layout.itemSize = CGSize(width: width, height: height)
        categoriesCollectionView?.collectionViewLayout = layout
    }

    fileprivate func setUpShopsCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let width = (view.frame.width - 65) / 3
        let height = width * 1.4
        layout.itemSize = CGSize(width: width, height: 190)
        shopsCollectionView?.collectionViewLayout = layout
    }
}

// MARK:- Loading
extension ShopsView {
    func showLoading(){
        startShimmerAnimation()
        categoriesCollectionView?.startShimmerAnimation(withIdentifier: ShopCategoryCell.identifier)
        shopsCollectionView?.startShimmerAnimation(withIdentifier: ShopCategoryCell.identifier)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        categoriesCollectionView?.stopShimmerAnimation()
        shopsCollectionView?.stopShimmerAnimation()
    }
}

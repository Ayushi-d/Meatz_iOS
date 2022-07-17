//
//  SearchResultView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/5/21.
//

import UIKit

final class SearchResultView: MainView {
    @IBOutlet private var itemsCountLabel: MediumLabel?
    @IBOutlet private var itemsButton: UIButton?
    @IBOutlet private var shopsButton: UIButton?
    @IBOutlet private var collectionView: UICollectionView?

    var viewModel: SearchResultVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        itemsCountLabel?.text = viewModel.itemsCount
        checkTabsState()
    }

    fileprivate func checkTabsState() {
        if viewModel.currentSelectedTab == .items {
            shopsButton?.backgroundColor = R.color.lightGray()
            itemsButton?.backgroundColor = R.color.maetzLightRed()
        } else {
            shopsButton?.backgroundColor = R.color.maetzLightRed()
            itemsButton?.backgroundColor = R.color.lightGray()
        }
    }

    fileprivate func loadData() {
        itemsCountLabel?.text = viewModel.itemsCount
        collectionView?.reloadData()
    }
}

// MARK: - Actions

extension SearchResultView {
    @IBAction func shopsPressed(_ sender: UIButton) {
        viewModel.currentSelectedTab = .shops
        checkTabsState()
        loadData()
    }

    @IBAction func itemsPressed(_ sender: UIButton) {
        viewModel.currentSelectedTab = .items
        checkTabsState()
        loadData()
    }
}

// MARK: - CollectionView

extension SearchResultView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentSelectedTab == .items ? viewModel.numberOfProducts : viewModel.numberOfStores
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.currentSelectedTab == .items {
            let cell = collectionView.dequeue(indexPath: indexPath, type: ProductCell.self)
            cell.viewModel = viewModel.viewModelForeItem(at: indexPath.item)
            return cell
        }
        let cell = collectionView.dequeue(indexPath: indexPath, type: ShopCell.self)
        cell.viewModel = viewModel.viewModelForStore(at: indexPath.item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.currentSelectedTab == .items {
            viewModel.didSelectItem(at: indexPath.item)
        } else {
            viewModel.didSelectStore(at: indexPath.item)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.currentSelectedTab == .items {
            let width_ = (view.frame.width - 65) / 2
            let height_ = width_ * 1.3
            return CGSize(width: width_, height: height_)
        }
        let width = (UIScreen.main.bounds.width - 65) / 3
        let height = width * 1.4
        return CGSize(width: width, height: height)
    }
}

// MARK:- Loading
extension SearchResultView {
    func showLoading(){
        startShimmerAnimation()
        collectionView?.startShimmerAnimation(withIdentifier: ProductCell.identifier)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        collectionView?.stopShimmerAnimation()
    }
}

//
//  WishlistView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/12/21.
//

import UIKit

final class WishlistView: MainView {
    @IBOutlet private var collectionView: UICollectionView?
    
    var viewModel: WhishlistVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        onError()
        onCompletion()
        showLoading()
        viewModel.onViewDidLoad()
    }
    
    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.hideLoading()
            self.showToast("", err.describtionError, completion: nil)
        }
    }
    
    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.hideLoading()
            self.collectionView?.reloadData()
            self.messageView(R.string.localizable.thereAreNoProducts(),
                             R.image.listEmpty(), hide: self.viewModel.numberOfItems != 0)
        }
    }
}

extension WishlistView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath, type: WishlistCell.self)
        let item = viewModel.viewModelForItem(at: indexPath.item)
        cell.viewModel = item
        cell.didPressFavIcon = { [weak self] item in
            guard let self = self else { return }
            self.dislikeItemWith(item.itemID)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width_ = (view.frame.width - 65) / 2
        let height_ = width_ * 1.34
        return CGSize(width: width_, height: height_)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.onViewDidLoad()
    }
    
    fileprivate func dislikeItemWith(_ id: Int) {
        showDialogue(R.string.localizable.removeItem(),
                     R.string.localizable.whishlistRemoveItemMessage(),
                     R.string.localizable.ok().uppercased()) { [unowned self] in
            self.showActivityIndicator()
            self.viewModel.disLike(id)
        }
    }
}

// MARK:- Loading
extension WishlistView {
    func showLoading(){
        startShimmerAnimation()
        collectionView?.startShimmerAnimation(withIdentifier: WishlistCell.identifier)
 
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        collectionView?.stopShimmerAnimation()
    }
}

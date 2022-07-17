//
//  FeaturedView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/30/21.
//

import UIKit

final class FeaturedView: MainView {
    @IBOutlet private var collectionView: UICollectionView?
    var viewModel: FeaturedVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems()
      //  setUpShopsCollectionLayout()
        onError()
        onCompletion()
        showLoading()
        viewModel.onViewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !navigationController!.viewControllers.contains(self){
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            if let err = error {
                self.hideLoading()
                self.showError(err)
            }
        }
    }
    fileprivate func onCompletion(){
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else{return}
            self.hideLoading()
            self.collectionView?.reloadData()
        }
    }
    
    deinit {
        print("featured stores is released ..")
    }
}

// MARK: - UICollectionView

extension FeaturedView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfShops
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath, type: ShopCell.self)
        cell.viewModel = viewModel?.viewModelForShop(at: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectShop(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/1.4)
    }
    
    
    
//    fileprivate func setUpShopsCollectionLayout() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 10
//        //layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        let width = collectionView?.frame.width ?? 0.0
//        let height = width/1.2
//        layout.itemSize = CGSize(width: width, height: height)
//        collectionView?.collectionViewLayout = layout
//    }
}

// MARK:- Loading
extension FeaturedView {
    func showLoading(){
        startShimmerAnimation()
        collectionView?.startShimmerAnimation(withIdentifier: ShopCell.identifier, numberOfRows: 20, numberOfSections: 1)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        collectionView?.stopShimmerAnimation()
    }
}

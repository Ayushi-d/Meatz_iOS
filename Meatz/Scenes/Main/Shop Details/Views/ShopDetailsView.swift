//
//  ShopDetailsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import UIKit

final class ShopDetailsView: MainView, TabsDelegate {
    
    
    @IBOutlet private weak var filterButton: UIButton?
    @IBOutlet private weak var sortButton: UIButton?
    @IBOutlet private var itemsCountLabel: BaseLabel!
    @IBOutlet private var shopNameLabel: BaseLabel?
    @IBOutlet private var shopLogoImageView: UIImageView?
    @IBOutlet private var collectionView: UICollectionView?
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet private var tabsView : TabsView!
    private var shopModel: ShopDetailsModel?
    var viewModel: ShopDetailsVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems()
        observeError()
        observeModel()
        observeActivity()
        observeRequestCompletion()
        viewModel.onViewDidLoad()
    }
    
    func setupTabs(model : ShopDetailsModel?){
        tabsView.backgroundColor = .clear
        
        guard let shopmodel = model else { return }
        
       // for i in 0...shopmodel.categories.count - 1 {
            guard let subcat = shopmodel.catProducts else {return}
            if subcat.count > 0 {
                for j in 0...subcat.count - 1{
                    guard let subCatName = subcat[j].subcategory else {return}
                    tabsView.tabs.append(Tab(icon: nil, title: subCatName ))
                }
            }
        //}
        tabsView.tabMode = .scrollable
        tabsView.titleColor = .black
        tabsView.indicatorColor = .black
        tabsView.backgroundColor = .clear
        tabsView.delegate = self
        if shopmodel.catProducts?.count ?? 0 > 0{
            tabsView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
        }
       
    }
    
    func tabsViewDidSelectItemAt(position: Int) {
        let nextItem: IndexPath = IndexPath(item: 0, section:position)
        collectionView?.selectItem(at: nextItem, animated: true, scrollPosition: .centeredVertically)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !navigationController!.viewControllers.contains(self) {
            tabBarController?.tabBar.isHidden = false
        }
    }

    fileprivate func observeActivity(){
        viewModel.activityIndicator.binding = { [weak self] visible in
            guard let self = self ,let visible_ = visible else{return}
            if visible_{
                self.showLoading()
            }else{
                self.hideLoading()
            }
        }
    }
    fileprivate func observeError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            if let err = error {
                self.showError(err)
            }
        }
    }

    fileprivate func observeModel() {
        viewModel.model.binding = { [weak self] model in
            guard let self = self else { return }
            self.shopNameLabel?.text = model?.name ?? ""
            self.shopLogoImageView?.loadImage(model?.banner ?? "")
            self.logoImage?.loadImage(model?.logo ?? "")
            self.itemsCountLabel.text = model?.productsCount ?? ""
            self.shopModel = model
            self.setupTabs(model: model)
        }
    }

    fileprivate func observeRequestCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.collectionView?.reloadData()
            let isEmpty = self.shopModel?.catProducts?.count == 0
            self.filterButton?.isEnabled = !isEmpty
            self.sortButton?.isEnabled = !isEmpty
            self.messageView2(R.string.localizable.thereAreNoProducts(),
                             nil, hide: !isEmpty)
        }
    }

    deinit {
        print(" Shop Details is released")
    }
}

// MARK: - Actions

extension ShopDetailsView {
    @IBAction func sort(_ sender: UIButton) {
        viewModel.sort()
    }

    @IBAction func filter(_ sender: UIButton) {
        viewModel.filter()
    }
}

// MARK: - CollectionView Delegete & DataSource

extension ShopDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return shopModel?.catProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return shopModel?.catProducts?[section].products?.count ?? 0
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let item = viewModel.viewModelForCell(at: indexPath.section, at: indexPath.item)
            let type = item.type
            if type == .sliderItem {
                let cell = collectionView.dequeue(indexPath: indexPath, type: BannerCell.self)
                cell.viewModel = item
                return cell
            } else {
                let cell = collectionView.dequeue(indexPath: indexPath, type: ProductCell.self)
                cell.viewModel = item
                return cell
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        let type = viewModel.viewModelForCell(at: indexPath.section, at: indexPath.item).type
            if type == .sliderItem{
                viewModel.didselectSliderItem(at: indexPath.item)
            }else{
                viewModel.didSelectProduct(at: indexPath.section, at: indexPath.item)
            }
        
    }
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let type = viewModel.viewModelForCell(at: indexPath.section, at: indexPath.item).type
            switch type {
            case .product, .specialOffer:
//                let width_ = (view.frame.width - 65) / 2
//                let height_ = width_ * 1.3
//                return CGSize(width: width_, height: 120)
                let width_ = (view.frame.width - 40)
                return CGSize(width: width_, height: 120)
            case .sliderItem:
                return CGSize(width: collectionView.frame.width - 40, height: 125)
            }
        //return CGSize(width: collectionView.frame.width - 40, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SubCatView", for: indexPath) as? SubCatView{
            sectionHeader.sectionHeaderlabel.text = tabsView.tabs[indexPath.section].title
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
}


// MARK:- Loading
extension ShopDetailsView {
    func showLoading(){
        startShimmerAnimation()
        collectionView?.startShimmerAnimation(withIdentifier: ProductCell.identifier)
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        collectionView?.stopShimmerAnimation()
    }
}

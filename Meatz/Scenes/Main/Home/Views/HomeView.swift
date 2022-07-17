//
//  HomeView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import UIKit

final class HomeView: MainView {
    @IBOutlet private var bottomBannerImageView: UIImageView?
    @IBOutlet private var selectionViewAllButton: BaseButton?
    @IBOutlet private var boxesViewAllButton: BaseButton?
    @IBOutlet private var boxesCollectionView: UICollectionView?
    @IBOutlet private var shopsCollectionView: UICollectionView?
    @IBOutlet private var pageControl: UIPageControl?
    @IBOutlet private var slidesShow: ZSlider?
    @IBOutlet private var categoriesCollectionView: UICollectionView?
    @IBOutlet weak var searchIcon: UIImageView!
    
    var viewModel: HomeVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchIcon.image = R.image.search()?.imageFlippedForRightToLeftLayoutDirection()
        if MOLHLanguage.isArabic(){
            pageControl?.semanticContentAttribute = .forceRightToLeft
        }
        
        showLoading()
    }

    private func showLoading(){
        startShimmerAnimation()
        
        categoriesCollectionView?.startShimmerAnimation(withIdentifier: ShopCategoryCell.identifier)
        
        shopsCollectionView?.startShimmerAnimation(withIdentifier: ShopCell.identifier)
        
        boxesCollectionView?.startShimmerAnimation(withIdentifier: HomeBoxCell.identifier)
        
        pageControl?.isHidden = true
        
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        
        categoriesCollectionView?.stopShimmerAnimation()
        
        shopsCollectionView?.stopShimmerAnimation()
        
        boxesCollectionView?.stopShimmerAnimation()
        
        pageControl?.isHidden = false
    }
    
    
    fileprivate func observeRequestCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.setUpSlidesShow()
            self.setUpPageControl()
            self.boxesCollectionView?.reloadData()
            self.shopsCollectionView?.reloadData()
            self.categoriesCollectionView?.reloadData()
           // self.boxesViewAllButton?.isHidden = self.viewModel.shouldHideViewAllBoxesButton
            self.hideLoading()
        }
    }

    fileprivate func observeRequestError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            guard let err = error else { return }
            self.showError(err)
            self.hideActivityIndicator()
        }
    }

    fileprivate func setUpPageControl() {
        pageControl?.pageIndicatorTintColor = R.color.meatzRed()
        if #available(iOS 14.0, *) {
            pageControl?.setIndicatorImage(R.image.rectangle164(), forPage: 0)
        } else {
            // Fallback on earlier versions
        }
        pageControl?.numberOfPages = self.viewModel.numberOfSliders
    }

    fileprivate func setUpSlidesShow() {
        slidesShow?.delegate = self
        slidesShow?.dataSource = self
        slidesShow?.reload()
    }
    
    override func notificationPressed() {
        viewModel.goToNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationItems(true)
        observeRequestCompletion()
        observeRequestError()
        viewModel.onViewDidLoad()
    }

}

// MARK: - Actions

extension HomeView {
    @IBAction func search(_ sender: UIButton) {
        viewModel.search()
    }

    @IBAction func viewAllBoxes(_ sender: UIButton) {
        viewModel.viewAllBoxes()
    }
    /// Navigates featured stores
    @IBAction func viewAllSelections(_ sender: UIButton) {
        viewModel.viewAllFeatured()
    }
    @IBAction func navigateToCreateBoxAction(_ sender: Any) {
        guard CachingManager.shared.isLogin else {
            self.showToast("", R.string.localizable.pleaseLoginFirst(), completion: nil)
            return
        }
        viewModel.navigattetoCreateBox()
    }
}

// MARK: - Slider

@available(iOS 14.0, *)
@available(iOS 14.0, *)
extension HomeView: ZSliderDelegate,ZSliderDataSource {
    func didDisplayItem(_ slider: ZSliderImageSliderView, At index: Int) {
        pageControl?.currentPage = index
        for i in 0..<pageControl!.numberOfPages {
            if i == index {
                pageControl?.setIndicatorImage(R.image.rectangle164(), forPage: i)
                pageControl?.currentPageIndicatorTintColor = #colorLiteral(red: 0.9450980392, green: 0.4705882353, blue: 0.4666666667, alpha: 1)
            } else {
                pageControl?.setIndicatorImage(nil, forPage: i)
                pageControl?.pageIndicatorTintColor = R.color.meatzRed()
            }
        }
    }
    
    func didSelectItem(_ slider: ZSliderImageSliderView, At index: Int) {
        viewModel.didselectSliderItem(at : index)
    }
    
    func imagesFor(_ slider: ZSliderImageSliderView) -> [ZSliderSource] {
        return viewModel.sliderInputSources()
    }
    
}

// MARK: - UICollectionView

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoriesCollectionView:
            return viewModel.numberOfCategories
        case shopsCollectionView:
            return viewModel.numberOfFeatured
        default:
            break
        }
        return viewModel.shouldHideViewAllBoxesButton ? 1 : viewModel.numberOfBoxes
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoriesCollectionView:
            let cell = collectionView.dequeue(indexPath: indexPath, type: ShopCategoryCell.self)
            cell.viewModel = viewModel.viewModelForCat(at: indexPath.item)
            return cell
        case shopsCollectionView:
            let cell = collectionView.dequeue(indexPath: indexPath, type: ShopCell.self)
            cell.viewModel = viewModel.viewModelForShop(at: indexPath.item)
            return cell
        default:
            break
        }
        // if boxes is empty i dequeue no box cell
        guard !viewModel.shouldHideViewAllBoxesButton else{
            return collectionView.dequeue(indexPath: indexPath, type: NoBoxCell.self)
        }
        let cell = collectionView.dequeue(indexPath: indexPath, type: HomeBoxCell.self)
        cell.viewModel = viewModel.viewModelForBox(at: indexPath.item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case shopsCollectionView:
            viewModel.didSelectShop(at: indexPath.item)
        case boxesCollectionView:
            viewModel.didSelectBox(at: indexPath.item)
        default:
            viewModel.didSelectCategory(at: indexPath.item)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView{
        case categoriesCollectionView:
            let width = (view.frame.width - 60) / 3
            let height = width 
            return CGSize(width: width, height: height)
        case shopsCollectionView:
            let width = (view.frame.width - 60) / 3
            let height = width * 1.3
            return CGSize(width: width, height: height)
        default:
            let width = view.frame.width * 0.65
            let height = CGFloat(170)
            return viewModel.shouldHideViewAllBoxesButton ? CGSize(width: view.frame.width - 40, height: height)  : CGSize(width: width, height: height)
        }
    }
    
}

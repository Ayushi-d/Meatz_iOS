//
//  BoxDetailsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/4/21.
//

import UIKit
@available(iOS 14.0, *)

final class BoxDetailsView: MainView {
    @IBOutlet private var pageControl: UIPageControl?
    @IBOutlet private var countStackView: UIStackView?
    @IBOutlet private var boxesCostLabel: BaseLabel?
    @IBOutlet private var boxesCountLabel: BoldLabel?
    @IBOutlet private var cartView: UIView?
    @IBOutlet private var contentLabel: BaseLabel?
    @IBOutlet private var personsCountLabel: BoldLabel?
    @IBOutlet private var priceBeforeView: UIView?
    @IBOutlet private var priceBeforeLabel: BaseLabel?
    @IBOutlet private var priceLabel: BoldLabel?
    @IBOutlet private var boxTitleLabel: MediumLabel?
    @IBOutlet private var slider: ZSlider!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet private weak var scrollViewHeightConstraint: NSLayoutConstraint?
    
    var viewModel: BoxDetailsVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        showLoading()
        observeBoxCount()
        onError()
        onCompletion()
        onReceivingMessage()
        viewModel.onViewDidLoad()
        countStackView?.isHidden = true
        addToCartView.isHidden = true
    }
    
    fileprivate func observeBoxCount() {
        viewModel.boxCount.binding = { [weak self] count in
            guard let self = self else { return }
            self.boxesCountLabel?.text = count?.toString ?? ""
            self.boxesCostLabel?.text = self.viewModel.boxesPrice
        }
    }
    
    fileprivate func onReceivingMessage(){
        viewModel.message.binding = { [weak self] message in
            guard let self = self else { return }
            self.hideLoading()
            self.showToast("", message ?? "", completion: nil)
        }
    }
    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.showError(err)
            self.hideLoading()
        }
    }
    
    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.hideLoading()
            self.loadData()
            self.setUpSlider()
        }
    }
    
    fileprivate func loadData() {
        pageControl?.numberOfPages = viewModel.sliderInput.count
        boxTitleLabel?.text = viewModel.boxName
        contentLabel?.text = viewModel.boxDescription
        priceLabel?.text = viewModel.boxPrice
        priceBeforeLabel?.text = viewModel.boxPriceBefore
        priceBeforeView?.isHidden = viewModel.shouldHidPriceBeforeView
        boxesCostLabel?.text = viewModel.boxesPrice
        boxesCountLabel?.text = viewModel.boxCount.value?.toString ?? ""
        countStackView?.isHidden = viewModel.shouldHideCountView
        addToCartView.isHidden = viewModel.shouldHideCountView
        personsCountLabel?.text = viewModel.personsCount
        updateScroll()
        if viewModel.shouldHideCountView {
            self.showDialogue(R.string.localizable.unavailable(), R.string.localizable.thisItemIsUnavailableNow(), R.string.localizable.ok().uppercased()) {}
            
        }
    }
    
    fileprivate func updateScroll(){
        let height = 275 + (contentLabel?.intrinsicContentSize.height ?? 0.0)
        UIView.animate(withDuration: 0.0) {
            self.scrollViewHeightConstraint?.constant = height >= self.view.frame.height ? height : self.view.frame.height - 50
        }
        view.layoutIfNeeded()
    }
    fileprivate func setUpSlider() {
        setUpPageControl()
        slider.delegate = self
        slider.dataSource = self
        slider.reload()
    }
    
    fileprivate func setUpPageControl() {
        pageControl?.currentPageIndicatorTintColor = #colorLiteral(red: 0.9450980392, green: 0.4705882353, blue: 0.4666666667, alpha: 1)
        pageControl?.pageIndicatorTintColor = R.color.meatzRed()
        pageControl?.setIndicatorImage(R.image.rectangle164(), forPage: 0)
        pageControl?.numberOfPages = viewModel.sliderInput.count
    }
}

// MARK: - Actions

extension BoxDetailsView {
    @IBAction func addToCart(_ sender: UIButton) {
        showActivityIndicator()
        viewModel.addToCart()
    }
    
    @IBAction func increaseCount(_ sender: UIButton) {
        viewModel.increaseCount()
    }
    
    @IBAction func decreaseCount(_ sender: UIButton) {
        viewModel.decreaseCount()
    }
}

// MARK: - Slider

extension BoxDetailsView: ZSliderDelegate, ZSliderDataSource {
    func didSelectItem(_ slider: ZSliderImageSliderView, At index: Int) {}
    
    func didDisplayItem(_ slider: ZSliderImageSliderView, At index: Int) {
        print(index)
        pageControl?.currentPage = index
        for i in 0..<pageControl!.numberOfPages {
            if i == index {
                pageControl?.setIndicatorImage(R.image.rectangle164(), forPage: i)
                pageControl?.pageIndicatorTintColor = R.color.meatzRed()
                pageControl?.currentPageIndicatorTintColor = #colorLiteral(red: 0.9450980392, green: 0.4705882353, blue: 0.4666666667, alpha: 1)
            } else {
                pageControl?.setIndicatorImage(nil, forPage: i)
                pageControl?.pageIndicatorTintColor = R.color.meatzRed()
            }
        }
    }
    
    func imagesFor(_ slider: ZSliderImageSliderView) -> [ZSliderSource] {
        return viewModel.sliderInput
    }
}


// MARK:- Loading
extension BoxDetailsView {
    func showLoading(){
        startShimmerAnimation()
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        hideActivityIndicator()
    }
}

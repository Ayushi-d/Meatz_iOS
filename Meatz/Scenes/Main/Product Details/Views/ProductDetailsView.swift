//
//  ProductDetailsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import UIKit

final class ProductDetailsView: MainView, PriceUpdate {
   
    @IBOutlet private var extrasView: BaseView!
    @IBOutlet private var scrollViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var QuantityLabel: BoldLabel?
    @IBOutlet private var optionsTableView: UITableView?
    @IBOutlet private var likeButton: UIButton?
    @IBOutlet private var totalPriceLabel: BaseLabel?
    @IBOutlet private var optionsViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var descLabel: BaseLabel?
    @IBOutlet private var priceLabel: BoldLabel?
    @IBOutlet weak var priceBefore: UILabel!
    @IBOutlet private var productNameLabel: MediumLabel?
    @IBOutlet private var pageControl: UIPageControl?
    @IBOutlet private var slider: ZSlider?
    
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var addToBoxView: UIView!
    @IBOutlet weak var addToCartHConstraint: NSLayoutConstraint!
    @IBOutlet weak var addToBoxHConstraint: NSLayoutConstraint!
    @IBOutlet weak var addToBoxBtn: UIButton!
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var currencyLbl: BaseLabel!
    
    var viewModel: ProductDetailsVMProtocol!
    private var optionPrice: Double = 0.0
    private var optionsCount: Int = 0
    private var isFavourite = false
///
    override func viewDidLoad() {
        super.viewDidLoad()
//        optionsTableView?.estimatedRowHeight = 60.0
//        optionsTableView?.rowHeight = UITableView.automaticDimension
        addNavigationItems()
        onError()
        onCompletion()
        observeQuantity()
        showLoading()
        viewModel.onViewDidLoad()
       // setupView(true, 0)
    }
    
    fileprivate func setupView(_ isHidden: Bool, _ constant: CGFloat) {
        addToBoxView.isHidden = isHidden
        addToCartView.isHidden = isHidden
        currencyLbl.isHidden = isHidden
        addToCartBtn.isHidden = isHidden
        quantityStackView.isHidden = isHidden
        addToBoxBtn.isHidden = isHidden
        addToBoxHConstraint.constant = constant
        addToCartHConstraint.constant = constant
    }
    
    fileprivate func setUpSlider() {
        setUpPageControl()
        slider?.delegate = self
        slider?.dataSource = self
        self.slider?.reload()
    }
    
    fileprivate func setUpPageControl() {
        pageControl?.currentPageIndicatorTintColor = #colorLiteral(red: 0.9450980392, green: 0.4705882353, blue: 0.4666666667, alpha: 1)
        pageControl?.pageIndicatorTintColor = .white
        pageControl?.numberOfPages = viewModel.sliderItems.count
        
        if #available(iOS 14.0, *) {
            pageControl?.setIndicatorImage(R.image.rectangle164(), forPage: 0)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func updateViewConstraints() {
        optionsViewHeightConstraint?.constant = (optionsTableView?.contentSize.height)!
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        var frame = self.optionsTableView?.frame
        frame?.size.height = self.optionsTableView!.contentSize.height
        self.optionsTableView!.frame = frame!
        super.viewDidLayoutSubviews()
        optionsViewHeightConstraint?.constant = (optionsTableView?.contentSize.height)!

    }
    
    

    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.showToast("", err.describtionError, completion: nil)
            self.hideLoading()
        }
    }
    
    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] message in
            guard let self = self else { return }

            if !(message ?? "").isEmpty {
                self.showToast("", message ?? "", completion: nil)
                return
            }
            self.hideLoading()
            self.loadData()
            self.setUpSlider()
            
            self.upateOptionViewHeight()
            self.optionsTableView?.reloadData()
        }
    }
    
    fileprivate func upateOptionViewHeight() {
        let isOptionsEmpty = viewModel.numberOfOptions == 0
        let optionsViewHeight = CGFloat(((viewModel.numberOfOptions + 1) * 50) + 20)
        optionsViewHeightConstraint?.constant = isOptionsEmpty ? 0 : optionsViewHeight
        scrollViewHeightConstraint?.constant = 450 + (descLabel?.intrinsicContentSize.height ?? 0.0) + (optionsViewHeightConstraint?.constant ?? 0.0)
        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func observeQuantity() {
        viewModel.userSelectedCount.binding = { [weak self] count in
            guard let self = self else { return }
            self.QuantityLabel?.text = count?.toString ?? ""
            let originalPrice = Double(count ?? 0) * self.viewModel.total.toDouble
            let optionsPrice = self.optionPrice * Double(count ?? 0)
            self.totalPriceLabel?.text = "\(originalPrice + optionsPrice)".convertToKwdFormat()
        }
    }
    
    fileprivate func loadData() {
        let likeImage = viewModel.isLiked ? UIImage.init(named: "like") : UIImage.init(named: "Not-liked")
        likeButton?.setImage(likeImage, for: .normal)
        isFavourite = !viewModel.isLiked
        pageControl?.numberOfPages = viewModel.sliderItems.count
        productNameLabel?.text = viewModel.productName
        descLabel?.text = viewModel.desctiption
        priceLabel?.text = viewModel.productPrice
        priceBefore.text = viewModel.priceBefore
        totalPriceLabel?.text = "\(viewModel.totalPrice)".convertToKwdFormat()
        guard viewModel.itemCount > 0 else {
            self.showDialogue(R.string.localizable.unavailable(), R.string.localizable.thisItemIsUnavailableNow(), R.string.localizable.ok().uppercased()) {}
            return
        }
        //setupView(false, 56)
    }
    
    fileprivate func showClearBoxDialogue(_ message: String) {
        showDialogue(R.string.localizable.addToMyBox(), message, R.string.localizable.clear()) { [weak self] in
            guard let self = self else { return }
            self.showActivityIndicator()
            self.viewModel.clearBox()
        }
    }
    
    fileprivate func showClearCartDialogue(_ message: String) {
        showDialogue(R.string.localizable.cart(), message, R.string.localizable.clear()) { [weak self] in
            guard let self = self else { return }
            self.showActivityIndicator()
            self.viewModel.clearCart()
        }
    }
    
    func updatePrice(price: String, isAdded: Bool,index: Int) {
        guard let optionPrice = Double(price) else { return }
        guard let currentPrice = Double(totalPriceLabel?.text ?? "") else { return }
        if isAdded == true{
            self.optionsCount += 1
            self.optionPrice += optionPrice
            let productCount = self.QuantityLabel?.text?.toDouble
            let total = currentPrice + (optionPrice * productCount!)
            totalPriceLabel?.text = "\(total)".convertToKwdFormat()
        }else{
            self.optionsCount -= 1
            self.optionPrice -= optionPrice
            let productCount = self.QuantityLabel?.text?.toDouble
            let total = currentPrice - (optionPrice * productCount!)
            totalPriceLabel?.text = "\(total)".convertToKwdFormat()
        }
    }
}


// MARK: - Actions

extension ProductDetailsView {
    @IBAction func increaseCount(_ sender: UIButton) {
        viewModel.increaseQuantity()
    }
    
    @IBAction func decreaseCount(_ sender: UIButton) {
        viewModel.decreaseQuantity()
    }
    
    @IBAction func addToMyBoxes(_ sender: UIButton) {
        guard CachingManager.shared.isLogin else {
            showToast("", R.string.localizable.pleaseLoginFirst(), completion: nil)
            return
        }
        viewModel.addToBoxes()
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        // showActivityIndicator()
        if CachingManager.shared.isLogin{
            viewModel.addToCart()

        }else{
            self.showToast("Error", "You need to login first", completion: nil)
        }
    }
    
    @IBAction func likePressed(_ sender: UIButton) {
        guard CachingManager.shared.isLogin else {
            showToast("", R.string.localizable.pleaseLoginFirst(), completion: nil)
            return
        }
        // ;// showActivityIndicator()
        
        if viewModel.isLiked {
            viewModel.isLiked = false
            likeButton?.setImage(#imageLiteral(resourceName: "Not-liked"), for: .normal)
        } else {
            viewModel.isLiked = true
            likeButton?.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        }
        viewModel.likeDisLike()
    }
}

// MARK: - TableView

extension ProductDetailsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfOptions
        //return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeue(MultiOptionsCell.self, indexPath: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MultiOptionsCell", for: indexPath) as? MultiOptionsCell else {return UITableViewCell() }
        cell.viewModel = viewModel
        cell.delegatePrice = self
       // cell(indexPath : indexPath, tableView : optionsTableView)
        cell.option = viewModel.optionForCell(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.didSelectOption(at: indexPath.row)
//
//        guard let optionPrice = Double(viewModel.detectOptionPrice(at: indexPath.row)) else {
//            return
//        }
//        guard let currentPrice = Double(totalPriceLabel?.text ?? "") else { return }
//        self.optionPrice += optionPrice
//        self.optionsCount += 1
//        let productCount = self.QuantityLabel?.text?.toDouble
//        let total = (optionPrice * productCount!) + currentPrice
//        totalPriceLabel?.text = "\(total)".convertToKwdFormat()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        viewModel.didDeSelectOption(at: indexPath.row)
//        guard let optionPrice = Double(viewModel.detectOptionPrice(at: indexPath.row)) else { return }
//        guard let currentPrice = Double(totalPriceLabel?.text ?? "") else { return }
//        self.optionsCount -= 1
//        self.optionPrice -= optionPrice
//        let productCount = self.QuantityLabel?.text?.toDouble
//        let total = currentPrice - (optionPrice * productCount!)
//        totalPriceLabel?.text = "\(total)".convertToKwdFormat()
    }
//
//
//   

}

extension ProductDetailsView: ZSliderDelegate, ZSliderDataSource {
    func didDisplayItem(_ slider: ZSliderImageSliderView, At index: Int) {
        pageControl?.currentPage = index
        for i in 0..<pageControl!.numberOfPages {
            if i == index {
                if #available(iOS 14.0, *) {
                    pageControl?.setIndicatorImage(R.image.rectangle164(), forPage: i)
                } else {
                    // Fallback on earlier versions
                }
                pageControl?.currentPageIndicatorTintColor = #colorLiteral(red: 0.9450980392, green: 0.4705882353, blue: 0.4666666667, alpha: 1)
            } else {
                if #available(iOS 14.0, *) {
                    pageControl?.setIndicatorImage(nil, forPage: i)
                } else {
                    // Fallback on earlier versions
                }
                pageControl?.pageIndicatorTintColor = .white
            }
        }
    }
    
    func didSelectItem(_ slider: ZSliderImageSliderView, At index: Int) {}
    
    func imagesFor(_ slider: ZSliderImageSliderView) -> [ZSliderSource] {
        return viewModel.sliderItems
    }
}


// MARK:- Loading
extension ProductDetailsView {
    func showLoading(){
        startShimmerAnimation()
        optionsTableView?.startShimmerAnimation(withIdentifier: MultiOptionsCell.identifier)

    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        optionsTableView?.stopShimmerAnimation()
    }
}


//extension ProductDetailsView: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfOptions
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue(ProductOptionCell.self, indexPath: indexPath)
//        cell.option = viewModel.optionForCell(at: indexPath.row)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.didSelectOption(at: indexPath.row)
//
//        guard let optionPrice = Double(viewModel.detectOptionPrice(at: indexPath.row)) else {
//            return
//        }
//        guard let currentPrice = Double(totalPriceLabel?.text ?? "") else { return }
//        self.optionPrice += optionPrice
//        self.optionsCount += 1
//        let productCount = self.QuantityLabel?.text?.toDouble
//        let total = (optionPrice * productCount!) + currentPrice
//        totalPriceLabel?.text = "\(total)".convertToKwdFormat()
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        viewModel.didDeSelectOption(at: indexPath.row)
//        guard let optionPrice = Double(viewModel.detectOptionPrice(at: indexPath.row)) else { return }
//        guard let currentPrice = Double(totalPriceLabel?.text ?? "") else { return }
//        self.optionsCount -= 1
//        self.optionPrice -= optionPrice
//        let productCount = self.QuantityLabel?.text?.toDouble
//        let total = currentPrice - (optionPrice * productCount!)
//        totalPriceLabel?.text = "\(total)".convertToKwdFormat()
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//}

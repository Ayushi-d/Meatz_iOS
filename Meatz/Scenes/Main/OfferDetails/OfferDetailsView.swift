//
//  OfferDetailsView.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/20/21.
//

import UIKit

class OfferDetailsView: MainView {
    
    @IBOutlet weak var sliderShow: ZSlider!
    @IBOutlet weak var pageControler: UIPageControl!
    @IBOutlet weak var offerNameLabel: MediumLabel!
    @IBOutlet weak var mainPriceLabel: BoldLabel!
    @IBOutlet weak var offerPriceLabel: BaseLabel!
    @IBOutlet weak var numberOfPersonesLabel: BoldLabel!
    @IBOutlet weak var sroreImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: MediumLabel!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var cartCountLabel: BoldLabel!
    @IBOutlet weak var cartPriceLabel: BaseLabel!
    @IBOutlet weak var addToCartView: UIView!
    
    var viewModel: OffrrDetailsVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems()
        setupTableView()
        self.showLoading()
        viewModel.viewOnDidLoad()
        observeRequestCompletion()
        observeRequestError()
        observeOfferDetails()
        
        if MOLHLanguage.isArabic(){
            pageControler?.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    
    
    fileprivate func setUpSlidesShow() {
        sliderShow?.delegate = self
        sliderShow?.dataSource = self
        sliderShow?.reload()
    }
    
    fileprivate func setUpPageControl() {
        pageControler?.currentPageIndicatorTintColor = R.color.meatzBlack()
        pageControler?.pageIndicatorTintColor = R.color.meatzRed()
        if #available(iOS 14.0, *) {
            pageControler?.setIndicatorImage(R.image.rectangle164(), forPage: 0)
        } else {
            // Fallback on earlier versions
        }
        pageControler?.numberOfPages = self.viewModel.numberOfSliders
    }
    
    fileprivate func observeOfferDetails() {
        viewModel.offerDetails.binding = { [weak self] model in
            guard let self = self else { return }
            self.offerNameLabel.text = model?.name
            self.mainPriceLabel.text = "\(model?.price ?? "") \(R.string.localizable.kwd())"
            
            self.offerPriceLabel.text = model?.priceBefore
            self.numberOfPersonesLabel.text = "\(model?.persons.toString ?? "")  \(R.string.localizable.persons())"
            
            self.storeNameLabel.text = model?.store.name
            self.sroreImageView.loadImage(model?.store.image ?? "")
            self.cartPriceLabel.text = "\(model?.price ?? "0.000") \(R.string.localizable.kwd())"
            self.addToCartView.isHidden = self.viewModel.shouldHideCountView
            if self.viewModel.shouldHideCountView {
                self.showDialogue(R.string.localizable.unavailable(), R.string.localizable.thisItemIsUnavailableNow(), R.string.localizable.ok().uppercased()) {}
                
            }
        }
        
        viewModel.currentCartNumber.binding = { [weak self] number in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.cartCountLabel.text = number?.toString
            }
        }
        
        viewModel.currentCartPrice.binding = { [weak self] price in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.cartPriceLabel.text = "\((price ?? 0).toString.convertToKwdFormat()) \(R.string.localizable.kwd())"
            }
            
        }
        
        viewModel.message.binding = { [weak self] message in
            guard let self = self else { return }
            self.hideLoading()
            self.showToast("", message ?? "", completion: nil)
        }
        
    }
    
    fileprivate func observeRequestCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.setUpSlidesShow()
            self.setUpPageControl()
            self.detailsTableView.reloadData()
            self.hideLoading()
            
        }
    }
    
    fileprivate func observeRequestError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            guard let err = error else { return }
            self.showError(err)
            self.hideLoading()
            
        }
    }
    
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        viewModel.minusCartCount()
    }
    
    @IBAction func plusCartButtonTapped(_ sender: Any) {
        viewModel.plusCartCount()
    }
    
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        showActivityIndicator()
        viewModel.addToCart()
    }
    
    
    
}

extension OfferDetailsView: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
//        detailsTableView.estimatedRowHeight = 500
//        detailsTableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfContentRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(OfferDetailsTableViewCell.self, indexPath: indexPath)
        cell.model = viewModel.getContentModel(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}


// MARK: - Slider

@available(iOS 14.0, *)
@available(iOS 14.0, *)
extension OfferDetailsView: ZSliderDelegate,ZSliderDataSource {
    func didDisplayItem(_ slider: ZSliderImageSliderView, At index: Int) {
        pageControler?.currentPage = index
        for i in 0..<pageControler!.numberOfPages {
            if i == index {
                pageControler?.setIndicatorImage(R.image.rectangle164(), forPage: i)
                pageControler?.currentPageIndicatorTintColor = R.color.meatzBlack()
            } else {
                pageControler?.setIndicatorImage(nil, forPage: i)
                pageControler?.pageIndicatorTintColor = R.color.meatzRed()
            }
        }
    }
    
    func didSelectItem(_ slider: ZSliderImageSliderView, At index: Int) {
       
    }
    
    func imagesFor(_ slider: ZSliderImageSliderView) -> [ZSliderSource] {
        return viewModel.sliderInputSources()
    }
    
}

// MARK:- Loading
extension OfferDetailsView {
    func showLoading(){
        startShimmerAnimation()
//        detailsTableView?.startShimmerAnimation(withIdentifier: OfferDetailsTableViewCell.identifier)
        
        detailsTableView?.startShimmerAnimation(withIdentifier: OfferDetailsTableViewCell.identifier, numberOfRows: 1, numberOfSections: 1)
 
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        detailsTableView?.stopShimmerAnimation()
        self.hideActivityIndicator()
        
    }
}

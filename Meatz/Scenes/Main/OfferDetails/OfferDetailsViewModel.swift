//
//  OfferDetailsViewModel.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/20/21.
//

import Foundation

class OfferDetailsViewModel: OffrrDetailsVMProtocol  {

    var offerDetails: Observable<OfferDetailsModel> = Observable(OfferDetailsModel(nil))
    var currentCartNumber: Observable<Int> = Observable(1)
    var currentCartPrice: Observable<Double> = Observable(0)
    var message: Observable<String> = Observable("")
    
    var state: State = .notStarted
    var onRequestCompletion: ((_ message : String?) -> Void)? //
    var requestError: Observable<ResultError>? = Observable(.none)
    var detailsContent: [String] = []
    var sliderImage: [String] = []
   
    
    private var repo: OfferDetailsRepoProtocol
    private var coordinator: Coordinator?
    private var offerId: Int
    
    init(offerId: Int, _ repo: OfferDetailsRepoProtocol, _ coordinator: Coordinator?) {
        self.offerId = offerId
        self.repo = repo
        self.coordinator = coordinator
    }
    
    var numberOfContentRows: Int {
        return detailsContent.count
    }
    
    var numberOfSliders: Int {
        return sliderImage.count
    }
    
    var shouldHideCountView: Bool {
        return (offerDetails.value?.stocks ?? 0) > 0 ?  false :  true
    }
    
    func viewOnDidLoad() {
        repo.getOffersData(offerId: offerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.state = .success
                guard let completion = self.onRequestCompletion else { return }
                self.offerDetails.value = model
                self.detailsContent = model.content
                self.sliderImage = model.images
                completion(nil)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }
    
    func getContentModel(at indexPath: IndexPath) -> String {
        return detailsContent[indexPath.row]
    }
    
    func sliderInputSources() -> [ZSliderSource] {
        return sliderImage.map { SliderInput(link:$0) }
    }
    
    func plusCartCount() {
        
        guard currentCartNumber.value ?? 0 < offerDetails.value?.stocks ?? 0  else {
            message.value = R.string.localizable.maxPrdctCount()
            return
        }
        
        currentCartNumber.value! += 1
        currentCartPrice.value = Double(currentCartNumber.value!) * (offerDetails.value?.price.toDouble ?? 0.0)
    }
    
    func minusCartCount() {
        if currentCartNumber.value ?? 0 > 1 {
            currentCartNumber.value! -= 1
            currentCartPrice.value = Double(currentCartNumber.value!) * (offerDetails.value?.price.toDouble ?? 0.0)
        }
    }
    
    func addToCart() {
        let parameters = AddToCartParams(id: offerId, count: currentCartNumber.value ?? 1)
        
        repo.addToCart(parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.message.value = model.message
                guard let completion = self.onRequestCompletion else { return }
                completion("")
            case .failure(let error):
                self.requestError?.value = error
            }
        }
    }
    
    

}

protocol OffrrDetailsVMProtocol: ViewModel {
    var offerDetails: Observable<OfferDetailsModel> { get set }
    var currentCartNumber: Observable<Int> { get set }
    var currentCartPrice: Observable<Double> { get set }
    var numberOfContentRows: Int { get }
    var numberOfSliders: Int { get }
    var shouldHideCountView: Bool { get }
    var message: Observable<String> { get set }
    
    func viewOnDidLoad()
    func getContentModel(at indexPath: IndexPath) -> String
    func sliderInputSources() -> [ZSliderSource]
    func plusCartCount()
    func minusCartCount()
    func addToCart()
}

//
//  BoxDetailsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/4/21.
//

import Foundation

final class BoxDetailsViewModel {
    private var repo: BoxDetailsRepoProtocol?
    private var coordinator: Coordinator?
    private var model: BoxDetailsModel?
    var boxCount: Observable<Int> = Observable(1)
    var onRequestCompletion: ((_ message : String?) -> Void)? 
    var requestError: Observable<ResultError>?
    var message: Observable<String> = Observable("")
    var state: State = .notStarted
    var id: Int!
    init(_ repo: BoxDetailsRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension BoxDetailsViewModel: BoxDetailsVMProtocol {
    var boxPrice: String {
        return (model?.price ?? "").addCurrency()
    }

    var boxPriceBefore: String {
        return (model?.priceBefore ?? "")
    }

    var boxName: String {
        return model?.name ?? ""
    }

    var boxDescription: String {
        return model?.content ?? ""
    }

    var boxesPrice: String {
        let currentCount = boxCount.value!
        let price = model?.price.toDouble ?? 0.0
        return String(Double(currentCount) * price).addCurrency()
    }

    var personsCount: String {
        return (model?.persons.toString ?? "") + " " + R.string.localizable.persons()
    }

    var shouldHideCountView: Bool {
        return (model?.num ?? 0) == 0
    }

    var shouldHidPriceBeforeView: Bool {
        return boxPriceBefore == "0"
    }

    var sliderInput: [SliderInput] {
        return model?.images ?? []
    }

    func onViewDidLoad() {
        guard id != nil else { fatalError("Please inject box id ") }
        repo?.getBoxDetails(id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.model = model
                self.state = .success
                guard let completion = self.onRequestCompletion else{return}
                completion(nil)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }

    func addToCart() {
        let params = AddToCartParams(id: id, count: boxCount.value ?? 1)
        repo?.addToCart(params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.message.value = model.message
            case .failure(let error):
                self.requestError?.value = error
            }
        }
    }

    func increaseCount() {
        let availableBoxesCount = model?.num ?? 0
        guard boxCount.value! < availableBoxesCount else {
            message.value = R.string.localizable.maxPrdctCount()
            return }
        boxCount.value! += 1
    }

    func decreaseCount() {
        guard boxCount.value! > 1 else { return }
        boxCount.value! -= 1
    }
}

protocol BoxDetailsVMProtocol: ViewModel {
    var personsCount: String { get }
    var boxPrice: String { get }
    var boxPriceBefore: String { get }
    var boxName: String { get }
    var boxDescription: String { get }
    var boxCount: Observable<Int> { get set }
    var message: Observable<String> { get set }
    var boxesPrice: String { get }
    var shouldHideCountView: Bool { get }
    var shouldHidPriceBeforeView: Bool { get }
    var sliderInput: [SliderInput] { get }
    
    func onViewDidLoad()
    func addToCart()
    func increaseCount()
    func decreaseCount()
}

struct AddToCartParams: Parameters {
    var id: Int
    var count: Int
    var options : String = ""
    var optionItmes : String = ""
    var body: [String: Any] {
//        if options.isEmpty {
//            return ["product_id": id,
//                    "count": count
//            ]
//        } else {
            return ["product_id": id,
                    "count": count,
                    "option_items":optionItmes]
        //}
        
    }
    
}


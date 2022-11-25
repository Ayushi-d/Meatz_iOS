//
//  OurBoxesViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/1/21.
//

import Foundation

final class OurBoxesViewModel {
    private var repo: OurBoxesRepoProtocol?
    private var coordinator: Coordinator?
    private var boxes: [BoxModel] = []
    private var model: OurBoxesModel?
    var onRequestCompletion: ((_ message : String?) -> Void)? 
    var requestError: Observable<ResultError>? = Observable(nil)
    var state: State = .notStarted

    init(_ repo: OurBoxesRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension OurBoxesViewModel: OurBoxesVMProtocol {
    var numberOfBoxes: Int {
        return boxes.count
    }

    var isEmpty: Bool {
        return boxes.isEmpty
    }

    var cartCount: String {
        return (model?.cart.count ?? 0).toString
    }

    var cartAmount: String {
        return (model?.cart.total ?? 0).toString + " " + R.string.localizable.kwd()
    }

    var availableBoxesCount: String {
        return numberOfBoxes.toString + " " + R.string.localizable.available()
    }

    var shouldHideCartView: Bool {
        return (model?.cart.count ?? 0) <= 0
    }

    func onViewDidLoad() {
        repo?.getOurBoxes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.model = model
                self.boxes = model.boxes
                self.state = .success
                guard let completion = self.onRequestCompletion else{return}
                completion(nil)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }

    func viewModelForCell(at index: Int) -> OurBoxViewModel {
        return boxes[index]
    }

    func didSelectBox(at index: Int) {
        let id = boxes[index].id
        coordinator?.navigateTo(MainDestination.box(id))
    }
    
    func viewCart() {
        coordinator?.navigateTo(MainDestination.cart)
    }
}

protocol OurBoxesVMProtocol: ViewModel {
    var numberOfBoxes: Int { get }
    var isEmpty: Bool { get }
    var shouldHideCartView: Bool { get }
    var cartCount: String { get }
    var cartAmount: String { get }
    var availableBoxesCount: String { get }

    func onViewDidLoad()
    func viewModelForCell(at index: Int) -> OurBoxViewModel
    func didSelectBox(at index: Int)
    func viewCart()

}

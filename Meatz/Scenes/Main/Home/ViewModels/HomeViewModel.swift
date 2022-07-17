//
//  HomeViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/30/21.
//

import Foundation

final class HomeViewModel {
    private var repo: HomeRepoProtocol?
    private var coordinator: Coordinator?
    private var slider: [SliderModel] = []
    private var boxes: [BoxModel] = []
    private var featured: [FeaturedModel] = []
    var categories: Observable<[CategoryModel]> = Observable([])

    var state: State = .notStarted
    var onRequestCompletion: ((_ message : String?) -> Void)? //
    var requestError: Observable<ResultError>? = Observable(.none)
    
    init(_ repo: HomeRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

// MARK: - Functionality

extension HomeViewModel: HomeVMProtocol {

    var shouldHideViewAllBoxesButton: Bool{
        return boxes.isEmpty
    }
    var numberOfCategories: Int {
        return categories.value?.count ?? 0
    }
    
    var numberOfSliders: Int {
        return slider.count
    }
    
    var numberOfBoxes: Int {
        return boxes.count
    }
    
    var numberOfFeatured: Int {
        return featured.count
    }
    
    func onViewDidLoad() {
        repo?.getHomeData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.populateWith(model)
                guard let completion = self.onRequestCompletion else{return}
                completion(nil)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }
    
    /// populates viewModel with returned model from api
    fileprivate func populateWith(_ model: HomeModel) {
        state = .success
        slider = model.sliders
        boxes = model.boxes
        categories.value = model.categories
        featured = model.featured
    }
    
    func viewModelForShop(at index: Int) -> Listable {
        return featured[index]
    }
    
    func viewModelForBox(at index: Int) -> OurBoxViewModel {
        return boxes[index]
    }
    
    func viewModelForCat(at index: Int) -> CategoryModel {
        return categories.value?[index] ?? CategoryModel(model: nil)
    }
    func sliderInputSources() -> [ZSliderSource] {
        return slider.map { SliderInput(link:$0.image) ?? SliderInput(link: "")}
    }
    
    func didSelectShop(at index: Int) {
        let id = featured[index].id
        coordinator?.navigateTo(MainDestination.shopDetails(id))
    }
    func didSelectBox(at index: Int) {
        guard !boxes.isEmpty else {return}
        let id = boxes[index].id
        coordinator?.navigateTo(MainDestination.box(id))
    }
    func didSelectCategory(at index: Int) {
        let cat = categories.value?[index] ?? CategoryModel(model: nil)
        coordinator?.navigateTo(MainDestination.category(cat))
    }
    
    func didselectSliderItem(at index: Int) {
        var destination : MainDestination!
        let item = slider[index]
        let type = item.type
        switch type{
        case .box:
            destination = .box(item.modelID)
        case .product:
            destination = .product(item.modelID)
        case .store:
            destination = .shopDetails(item.modelID)
        default:
            return
        }
        coordinator?.navigateTo(destination)
    }
    func search() {
        coordinator?.navigateTo(MainDestination.search)
    }
    func viewAllBoxes() {
        coordinator?.navigateTo(MainDestination.ourBoxes)
    }
    
    func viewAllFeatured() {
        coordinator?.navigateTo(MainDestination.featured)
    }
    
    func goToNotification() {
        coordinator?.navigateTo(MainDestination.notifications)
    }
    
    func navigattetoCreateBox(){
        coordinator?.navigateTo(MainDestination.createBox)
    }
}


//MARK:- ViewModel Protocols
protocol HomeVMProtocol: ViewModel , HomeCountable , HomeViewModels , HomeSelectable{
    func onViewDidLoad()
    func sliderInputSources() -> [ZSliderSource]
    func search()
    func viewAllBoxes()
    func viewAllFeatured()
    func navigattetoCreateBox()
}

protocol HomeSelectable{
    func didSelectShop(at index : Int)
    func didSelectBox(at index : Int)
    func didSelectCategory(at index : Int)
    func didselectSliderItem(at index : Int)
    func goToNotification()
}

protocol HomeViewModels{
    func viewModelForShop(at index: Int) -> Listable
    func viewModelForBox(at index: Int) -> OurBoxViewModel
    func viewModelForCat(at index : Int) -> CategoryModel
}
protocol HomeCountable {
    var numberOfCategories: Int { get }
    var numberOfSliders: Int { get }
    var numberOfBoxes: Int { get }
    var numberOfFeatured: Int { get }
    var shouldHideViewAllBoxesButton : Bool{get}
    var categories: Observable<[CategoryModel]> { get set }
    
}

//
//  HomeViewModelMock.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/3/21.
//

import Foundation

final class HomeViewModelMock : HomeVMProtocol{
    
    
    private var slider: [SliderModel] = []
    private var boxes: [BoxModel] = []
    private var featured: [FeaturedModel] = []
    private var repo: HomeRepoProtocol?
    private var coordinator: Coordinator?
    
    var categories: Observable<[CategoryModel]> = Observable([])
    
    
    
    
    init(_ repo: HomeRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
    private (set) var isOnViewDidLoadCalled : Bool = false
    func onViewDidLoad() {
        isOnViewDidLoadCalled = true
    }
    
    func sliderInputSources() -> [ZSliderSource] {
        return [SliderInput(link: "first"),
                SliderInput(link: "second"),
                SliderInput(link: "third")]
    }
    private (set) var isSearchCalled : Bool = false
    func search() {
        isSearchCalled = true
    }
    
    func navigattetoCreateBox() {
        //
    }
    
    private (set) var isViewAllBoxesCalled : Bool = false
    func viewAllBoxes() {
        isViewAllBoxesCalled = true
    }
    
    private (set) var isViewAllFeaturedCalled : Bool = false
    func viewAllFeatured() {
        isViewAllFeaturedCalled = true
    }
    
    
    var state: State = .notStarted
    
    var onRequestCompletion: ((_ message : String?) -> Void)? 
    
    var requestError: Observable<ResultError>?
    
    var numberOfCategories: Int{
        return categories.value?.count ??  0
    }
    
    var numberOfSliders: Int{
        return slider.count
    }
    
    var numberOfBoxes: Int{
        return boxes.count
    }
    
    var numberOfFeatured: Int{
        return featured.count
    }
    
    var shouldHideViewAllBoxesButton: Bool{
        return boxes.isEmpty
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
    
    private (set) var isDidSelectShopCalled : Bool = false
    func didSelectShop(at index: Int) {
        isDidSelectShopCalled = true
    }
    
    private (set) var isDidSelectBoxCalled : Bool = false
    func didSelectBox(at index: Int) {
        isDidSelectBoxCalled = true
    }
    private (set) var isDidSelectCategoryCalled : Bool = false
    func didSelectCategory(at index: Int) {
        isDidSelectBoxCalled = true
    }
    private (set) var isDidselectSliderItemCalled : Bool = false
    func didselectSliderItem(at index: Int) {
        isDidselectSliderItemCalled = true
    }
    
    func goToNotification() {
        
    }
    
}

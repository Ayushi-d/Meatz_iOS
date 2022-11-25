//
//  HomeViewModelTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 4/1/21.
//

import XCTest
@testable import Meatz

final class HomeViewModelTests: XCTestCase {
    //MARK:- Setup
    var sut : HomeViewModel!
    var coordinator : MainCoordinatorStub!
    var repo : HomeRepoProtocol!
    
    
    override func setUp() {
        super.setUp()
        coordinator = MainCoordinatorStub(UINavigationController())
        repo = HomeRepoStub()
        sut = HomeViewModel(repo, coordinator)
    }
    
//MARK:- non-categorized
    func testShouldHideViewAllBoxesButton(){
        sut.onViewDidLoad()
        XCTAssertFalse(sut.shouldHideViewAllBoxesButton)
    }
    
    func testSliderInputSources(){
       sut.onViewDidLoad()
       let input = sut.sliderInputSources()
        XCTAssertTrue(input.contains(where: {$0.urlString == "slider first link"}))
        XCTAssertTrue(input.contains(where: {$0.urlString == "slider second link"}))
    }
    
//MARK:- Counts
    func testNumberOfCategories(){
        XCTAssertEqual(sut.numberOfCategories, 3)
    }
    
    func testNumberOfSliders(){
        sut.onViewDidLoad()
        XCTAssertEqual(sut.numberOfSliders, 3)
    }
    
    func testNumberOfFeatured(){
        sut.onViewDidLoad()
        XCTAssertEqual(sut.numberOfFeatured, 3)
    }
    func testNumberOfBoxes(){
        sut.onViewDidLoad()
        XCTAssertEqual(sut.numberOfBoxes, 2)
    }
//MARK:- Request
    func testOnViewDidLoad(){
        sut.onViewDidLoad()
        XCTAssertEqual(sut.state, .success)
        XCTAssertNotEqual(sut.numberOfSliders, 0)
        XCTAssertNotEqual(sut.numberOfBoxes, 0)
        XCTAssertNotEqual(sut.numberOfFeatured, 0)
        if sut.state == .success{
            XCTAssertNil(sut.requestError?.value)
        }else{
            XCTAssertNotNil(sut.requestError?.value)
        }
    }
//MARK:- Request failure
    /// to run this failure please inject HomeRepoFailureStub in  setup  funciton
    func testRequestFailure(){
       sut.onViewDidLoad()
        if sut.state != .success
        {
            let supposedMessage = ResultError.messageError("Home request failure")
            XCTAssertEqual(sut.requestError?.value?.describtionError ?? "", supposedMessage.describtionError)
        }
    }
    
//MARK:- ViewModels
    func testViewModelForShop(){
        sut.onViewDidLoad()
        let item = sut.viewModelForShop(at: 0)
        XCTAssertEqual(item.itemName, "first shop")
        let secondItem = sut.viewModelForShop(at: 1)
        XCTAssertEqual(secondItem.itemName, "second shop")
    }
    
    func testViewModelForCat(){
        sut.onViewDidLoad()
        let cat = sut.viewModelForCat(at: 0)
        XCTAssertEqual(cat.categoryName, "Meat")
        let secondCat = sut.viewModelForCat(at: 1)
        XCTAssertEqual(secondCat.categoryName, "Poultry")
    }

    func testViewModelForBox(){
       sut.onViewDidLoad()
       let box = sut.viewModelForBox(at: 0)
        XCTAssertEqual(box.boxName, "first box")
        let secondBox = sut.viewModelForBox(at: 1)
        XCTAssertEqual(secondBox.boxName, "second box")
    }
    
//MARK:- Select actions
    
    func testDidSelectShop() {
        sut.onViewDidLoad()
        sut.didSelectShop(at: 0)
        let dest = coordinator.currentlyNavigatedDestination
        XCTAssertTrue(dest == .shopDetails(1))
    }
    
    func testDidSelectBox() {
        sut.onViewDidLoad()
        sut.didSelectBox(at: 1)
        let dest = coordinator.currentlyNavigatedDestination
        XCTAssertTrue(dest == .box(2)) /// 2 is the id of the box 
    }
    func testDidSelectCategory() {
        sut.onViewDidLoad()
        sut.didSelectCategory(at: 0)
        let dest = coordinator.currentlyNavigatedDestination
        let cat = sut.viewModelForCat(at: 0)
        XCTAssertTrue(dest == .category(cat))
    }
//
    func testDidselectSliderItem() {
        sut.onViewDidLoad()
        
        sut.didselectSliderItem(at: 0)
        XCTAssertEqual(coordinator.currentlyNavigatedDestination,
                       .box(1))
        
        sut.didselectSliderItem(at: 1)
        XCTAssertEqual(coordinator.currentlyNavigatedDestination,
                       .shopDetails(22))
        
        sut.didselectSliderItem(at: 2)
        XCTAssertEqual(coordinator.currentlyNavigatedDestination,
                       .product(15))
    }
    
    func testViewAllBoxes() {
        sut.viewAllBoxes()
        XCTAssertEqual(coordinator.currentlyNavigatedDestination,
                       .ourBoxes)
    }
    
    func testViewAllFeatured() {
        sut.viewAllFeatured()
        XCTAssertEqual(coordinator.currentlyNavigatedDestination,
                       .featured)
    }
    
    override func tearDown() {
        repo = nil
        coordinator = nil
        sut = nil
        super.tearDown()
    }
}

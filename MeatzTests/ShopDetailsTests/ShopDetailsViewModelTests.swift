//
//  ShopDetailsViewModelTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/29/21.
//

import XCTest
@testable import Meatz

final class ShopDetailsViewModelTests: XCTestCase {
    var sut : ShopDetailsViewModel!
    var repo : ShopDetailsRepoProtocol!
    var coordinator : MainCoordinatorStub!
    override func setUp() {
        super.setUp()
        repo = ShopDetailsRepoStub()
        coordinator = MainCoordinatorStub(UINavigationController())
        sut = ShopDetailsViewModel(repo, coordinator)
        sut.shopID = 1
    }

    
    func testNumberOfProducts() {
        sut.onViewDidLoad()
        XCTAssertEqual(sut.numberOfProducts, 9) //// number of products 8 + 1 ads
    }

    func testOnViewDidLoad(){
        sut.onViewDidLoad()
        XCTAssertNotNil(sut.model?.value) /// model should not be nil and products as stub success
        XCTAssertFalse(sut.numberOfProducts == 0)
        XCTAssertTrue(sut.state == .success)
    }
    
    func testState(){
        sut.onViewDidLoad()
        XCTAssertTrue(sut.state == .success)
    }
    func testOnViewDidLoadShopIDNil(){
        sut.shopID = nil
        XCTAssertEqual(sut.state, .notStarted)
    }
    
    func testPopulateItemsWithAds(){
        sut.onViewDidLoad()
        let itemViewModel = sut.viewModelForCell(at: 6)
        XCTAssertEqual(itemViewModel.type, .sliderItem)
        XCTAssertEqual(itemViewModel.itemName, "")
        XCTAssertEqual(itemViewModel.itemID, 100)
    }
    func testViewModelForCell(){
        sut.onViewDidLoad()
        let product = sut.viewModelForCell(at: 0) /// first product i.e stub contains only 1 product
        XCTAssertTrue(product.itemName == "First Product")
        let secondProduct = sut.viewModelForCell(at: 1)
        XCTAssertTrue(secondProduct.itemName == "Second Product")
    }
    
    func testFilter(){
        sut.onViewDidLoad()
        sut.filter()
        let destination = coordinator.currentlyPresentedDestination
        /// making sure that destination is filterView
        XCTAssertTrue(destination == MainDestination.filterView(nil))
    }
    
    func testSort(){
        sut.onViewDidLoad()
        sut.sort()
        let destination = coordinator.currentlyPresentedDestination
        ///making sure that destination is sortView
        XCTAssertTrue(destination == MainDestination.sort(nil))
    }
    
    override func tearDown() {
        coordinator = nil
        repo = nil
        sut = nil
        super.tearDown()
    }
   
    

}

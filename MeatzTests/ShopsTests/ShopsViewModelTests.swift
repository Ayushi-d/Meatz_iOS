//
//  ShopsViewModelTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/28/21.
//

import Foundation
import XCTest
@testable import Meatz

final class ShopsViewModelTests : XCTestCase{
    var sut : ShopsViewModel!
    var repo : ShopsRepoStub!
    var coordinator : MainCoordinatorStub!
    override func setUp() {
        super.setUp()
        repo = ShopsRepoStub()
        coordinator = MainCoordinatorStub(UINavigationController())
        sut = ShopsViewModel(repo, coordinator)
    }
    
    func testOnViewDidLoad(){
        sut.onViewDidLoad()
        XCTAssertFalse(sut.state == .notStarted)
    }
    
    func testnumberOfShops(){
        sut.onViewDidLoad()
        XCTAssertEqual(sut.numberOfShops, 2)
    }
    
    func testCategoryForItem(){
        let firstCategory = sut.categoryForItem(at: 0)
        XCTAssertEqual(firstCategory.categoryName, "Meat")
        let secondCategory = sut.categoryForItem(at: 1)
        XCTAssertEqual(secondCategory.categoryName, "Poultry")
        let thirdCategory = sut.categoryForItem(at: 2)
        XCTAssertEqual(thirdCategory.categoryName, "Fish")
    }
    
    func testShopForItem(){
        sut.onViewDidLoad()
        XCTAssertFalse(sut.numberOfShops == 0)
        let firstShop = sut.shopForItem(at: 0)
        XCTAssertEqual(firstShop.itemName, "First Shop")
        let secondShop = sut.shopForItem(at: 1)
        XCTAssertEqual(secondShop.itemName, "Second Shop")
    }
    
    func testSelectCategoryAt(){
        sut.selectCategory(at: 0)
        /// testing first cateogry selection
        XCTAssertTrue(sut.categoryForItem(at: 0).isSelected)
        XCTAssertFalse(sut.categoryForItem(at: 1).isSelected)
        XCTAssertFalse(sut.categoryForItem(at: 2).isSelected)
        /// testing second category selection
        sut.selectCategory(at: 1)
        XCTAssertTrue(sut.categoryForItem(at: 1).isSelected)
        XCTAssertFalse(sut.categoryForItem(at: 0).isSelected)
        XCTAssertFalse(sut.categoryForItem(at: 2).isSelected)
    }
    
    func testSelectShopAtIndex(){
        sut.onViewDidLoad()
        sut.selectShop(at: 1)
        let shop = sut.shopForItem(at: 1)
        XCTAssertTrue(coordinator.currentlyNavigatedDestination == MainDestination.shopDetails(shop.itemID))
        
    }
    override func tearDown() {
        repo = nil
        coordinator = nil
        sut = nil
        super.tearDown()
    }
    
}

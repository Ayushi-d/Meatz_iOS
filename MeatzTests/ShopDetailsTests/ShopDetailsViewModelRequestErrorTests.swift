//
//  ShopDetailsViewModelRequestErrorTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/29/21.
//

import XCTest
@testable import Meatz
/// Test case for request failure
final class ShopDetailsViewModelRequestErrorTests: XCTestCase {
    var sut : ShopDetailsViewModel!
    var repo : ShopDetailsRepoProtocol!
    var coordinator : Coordinator!
    
    override func setUp() {
        super.setUp()
        repo = ShopDetailsRepoFailureStub()
        coordinator = MainCoordinatorStub(UINavigationController())
        sut = ShopDetailsViewModel(repo, coordinator)
        sut.shopID = 1
    }

    func testOnviewDidLoad(){
        sut.onViewDidLoad()
        XCTAssertNotNil(sut.requestError?.value)
        let error : ResultError = .messageError("message for test")
        let state : State = .finishWithError(error) /// the same state exist in the stub
        XCTAssertEqual(sut.state,state)
    }
    override func tearDown() {
        coordinator = nil
        repo = nil
        sut = nil
        super.tearDown()
    }
}

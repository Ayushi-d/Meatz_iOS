//
//  HomeViewTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 4/3/21.
//

import XCTest
@testable import Meatz
final class HomeViewTests: XCTestCase {

    var sut : HomeView!
    var vm : HomeViewModelMock!
    override func setUp() {
        super.setUp()
        let sut =  R.storyboard.main.homeView()!
        vm = HomeViewModelMock(HomeRepoStub(), MainCoordinatorStub(UINavigationController()))
        sut.viewModel = vm
        sut.loadViewIfNeeded()
    }

    func testViewDidLoad(){
        XCTAssertTrue(vm.isOnViewDidLoadCalled)
        XCTAssertNotNil(vm.onRequestCompletion)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}

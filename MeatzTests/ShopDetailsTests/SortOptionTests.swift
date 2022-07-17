//
//  SortOptionTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/30/21.
//

import XCTest
@testable import Meatz

final class SortOptionTests: XCTestCase {
    var sut : SortOption!
    override func setUp() {
        super.setUp()
        sut = .high_price
    }

    func testTitle(){
        XCTAssertEqual(sut.title, "Price (High to Low)")
        
        sut = .low_price
        XCTAssertEqual(sut.title, "Price (Low to High)")
       
        sut = .latest
        XCTAssertEqual(sut.title, "Newest")
       
    }
    override func tearDown() {
        sut = nil 
        super.tearDown()
    }
    
}

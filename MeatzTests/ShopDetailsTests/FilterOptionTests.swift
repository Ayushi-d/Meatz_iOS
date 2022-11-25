//
//  FilterOptionTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/30/21.
//

import XCTest
@testable import Meatz
final class FilterOptionTests: XCTestCase {
    var sut : FilterOption!
    override func setUp() {
        super.setUp()
        sut = .meat
    }

    func testTitleAndCatID(){
        XCTAssertEqual(sut.title, "Meat")
        XCTAssertEqual(sut.rawValue, 1)
        
        sut = .poultry
        XCTAssertEqual(sut.title, "Poultry")
        XCTAssertEqual(sut.rawValue, 2)
       
        sut = .fish
        XCTAssertEqual(sut.title, "Fish")
        XCTAssertEqual(sut.rawValue, 3)
       
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
}

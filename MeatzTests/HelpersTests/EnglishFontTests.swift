//
//  EnglishFontTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/24/21.
//

import XCTest
@testable import Meatz

final class EnglishFontTests: XCTestCase {

    var sut : EnglishFont!
    override  func setUp() {
        super.setUp()
        sut = EnglishFont(.regular)
    }

    
    func testRegular(){
        XCTAssertTrue(sut.fontName == "Poppins-Regular")
    }

    func testMedium(){
        sut = EnglishFont(.medium)
        XCTAssertTrue(sut.fontName == "Poppins-Medium")
    }
    
    func testBold(){
        sut = EnglishFont(.bold)
        XCTAssertTrue(sut.fontName == "Poppins-Bold")
    }
    
    func testSemiBold(){
        sut = EnglishFont(.semiBold)
        XCTAssertTrue(sut.fontName == "Poppins-SemiBold")
    }
  
    override func tearDown() {
        super.tearDown()
    }
}

//
//  ArabicFontTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/24/21.
//

import XCTest
@testable import Meatz

final class ArabicFontTests: XCTestCase {

    var sut : ArabicFont!
    override func setUp() {
        super.setUp()
        sut = ArabicFont(.regular)
    }

    func testRegular(){
        XCTAssertTrue(sut.fontName == "Almarai-Regular")
    }

    func testBold(){
        sut = ArabicFont(.bold)
        XCTAssertTrue(sut.fontName == "Almarai-Bold")
    }
    
    func testLight(){
        sut = ArabicFont(.light)
        XCTAssertTrue(sut.fontName == "Almarai-Light")
    }
    
    func testExtraBold(){
        sut = ArabicFont(.extraBold)
        XCTAssertTrue(sut.fontName == "Almarai-ExtraBold")
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

}

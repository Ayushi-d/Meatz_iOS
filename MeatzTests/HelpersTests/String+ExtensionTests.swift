//
//  String+ExtensionTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/24/21.
//

import XCTest
@testable import Meatz

final class String_ExtensionTests: XCTestCase {

    var sut : String!
    
    override func setUp() {
        super.setUp()
    }
    
    func testToInt(){
        sut = "100"
        XCTAssertEqual(sut.toInt(),100)
        sut = "not integer string"
        XCTAssertEqual(sut.toInt(), 0)
    }
    
    func testToDouble(){
        sut = "10.0012"
        XCTAssertEqual(sut.toDouble, 10.0012)
        sut = "not double string"
        XCTAssertEqual(sut.toDouble, 0.0)
    }
    func testIsValidEmail() throws {
        sut = "meatz@domain.com"
        XCTAssertTrue(sut.isValidEmail())
        sut = "not email"
        XCTAssertFalse(sut.isValidEmail())
    }
    
    func testConverToKwdFormat(){
        sut = "500.321003321"
        XCTAssertEqual("500.321",sut.convertToKwdFormat())
    }

    func testAddCurrency(){
        sut = "50.000"
        XCTAssertEqual("50.000 KWD", sut.addCurrency())
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

}

//
//  Int+ExtensionTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/24/21.
//

import XCTest
@testable import Meatz

final class Int_ExtensionTests: XCTestCase {
    
    var sut : Int!
    override  func setUp() {
        super.setUp()
        sut = 100
    }
    
    func testToInt(){
        XCTAssertEqual("100", sut.toString)
    }
    
    override func tearDown() {
        sut = nil 
        super.tearDown()
    }

}

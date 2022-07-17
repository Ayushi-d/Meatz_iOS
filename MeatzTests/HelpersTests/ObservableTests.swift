//
//  ObservableTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/24/21.
//

import XCTest
@testable import Meatz
final class ObservableTests: XCTestCase {
    var sut : Observable<String>!
    override  func setUp() {
        super.setUp()
        sut = Observable<String>.init("Initial value")
    }

    

    func testValue(){
        XCTAssertTrue(sut.value == "Initial value")
        sut.value = "Hello"
        XCTAssertTrue(sut.value == "Hello")
    }
    
    func testBinding(){
        var testableString = "intial value "
        sut.binding = {text in
            testableString = text ?? ""
        }
        
        sut.value = "next value"
        XCTAssertTrue(testableString == "next value")
    }

  
}

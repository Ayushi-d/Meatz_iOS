//
//  CachingManagerTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/24/21.
//

import Foundation
import XCTest
@testable import Meatz

final class CachingManagerTests : XCTestCase{
    var sut : CachingManager!
    
    override func setUp() {
        super.setUp()
        sut = CachingManager.shared
    }
    /// tests login flag
    func testIsLogin(){
        sut.setLogin(true)
        XCTAssertTrue(sut.isLogin)
    }
    
    func testConfigLangSelected(){
        sut.reset()
        sut.configLangSelected()
        XCTAssertTrue(!sut.isFirstTime)
    }
    /// tests first open flag
    func testFirstTime(){
        if sut.isFirstTime{
            XCTAssertTrue(sut.isFirstTime)
        }else{
            sut.configLangSelected() /// called to change first open flag 
            XCTAssertTrue(!sut.isFirstTime)
        }
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}

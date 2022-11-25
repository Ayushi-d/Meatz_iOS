//
//  ShopDetailsParamsTests.swift
//  MeatzTests
//
//  Created by Mohamed Zead on 3/30/21.
//

import XCTest
@testable import Meatz

final class ShopDetailsParamsTests: XCTestCase {

    var sut : ShopDetailsParams!
    
    override func setUp() {
        super.setUp()
        sut = ShopDetailsParams()
    }
    
    func testBody(){
        sut.category = .fish
        sut.option = .low_price
        let correctBody : [String : Any] = ["filter_by": "low_price",
                                            "category_id": 3]
        XCTAssertEqual(correctBody.keys, sut.body.keys)
        XCTAssertEqual(sut.category!.rawValue, 3)
        XCTAssertEqual(sut.option!.rawValue, "low_price")
        
        sut.category = .meat
        sut.option = .high_price
        XCTAssertEqual(sut.category!.rawValue, 1)
        XCTAssertEqual(sut.option!.rawValue, "high_price")
        
        sut.category = .poultry
        sut.option = .latest
        XCTAssertEqual(sut.category!.rawValue, 2)
        XCTAssertEqual(sut.option!.rawValue, "latest")
    }
    
    

}

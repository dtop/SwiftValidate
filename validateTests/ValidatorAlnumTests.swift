//
//  ValidatorAlnumTests.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import validate

class ValidatorAlnumTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidator() {

        let validator = ValidatorAlnum() {
            $0.allowEmpty = true
        }
        
        var result: Bool = true
        
        do {
            
            result = try validator.validate("", context: nil)
            XCTAssertTrue(result)
            
            result = try validator.validate("abc♣adadad", context: nil)
            XCTAssertFalse(result)
            
            result = try validator.validate("dfgjkljgkldfg", context: nil)
            XCTAssertTrue(result)
            
        } catch let error as NSError {
            
            print(error)
        }
        
    }
    
}

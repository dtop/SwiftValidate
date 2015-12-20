//
//  MockValidator.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation
@testable import validate

class MockValidator: _BaseValidator, ValidatorProtocol {
    
    var someSetting: Bool = false
    
    required init(@noescape _ initializer: MockValidator -> ()) {
        
        super.init()
        initializer(self)
    }
    
    override func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        if let boolVal = value as? Bool {
            
            return boolVal || self.returnError("Some error string")
        }
        
        return self.returnError("Some other error string")
    }
}
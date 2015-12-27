//
//  MockValidator.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation
@testable import SwiftValidate

class MockValidator: BaseValidator, ValidatorProtocol {
    
    var allowNil: Bool = true
    
    var returnValue: Bool = true
    
    var throwException: Bool = false
    
    
    
    required init(@noescape _ initializer: MockValidator -> ()) {
        
        super.init()
        initializer(self)
    }
    
    override func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        if self.throwException {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Exception Thrown"])
        }
        
        if self.allowNil && nil == value {
            return true
        }
        
        if !self.returnValue {
            
            return self.returnError("Some error string")
        }
        
        return true
    }
}

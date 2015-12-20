//
//  ValidatorCallback.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorCallback: _BaseValidator, ValidatorProtocol {
    
    /// Holds the callback
    var callback: ((validator: ValidatorCallback, value: Any?, context: [String : Any?]?) throws -> (result: Bool, errorMessage: String?))!
    
    /**
     Init
     
     - parameter initializer: initializer for easy setup
     
     - returns: the instance
     */
    required public init(@noescape _ initializer: ValidatorCallback -> ()) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Validates the value by calling the callback
     
     - parameter value:   the value
     - parameter context: the context
     
     - throws: validation errors
     
     - returns: true if ok
     */
    public override func validate<T : Any>(value: T?, context: [String : Any?]?) throws -> Bool {
        
        if nil == self.callback {
            
            throw NSError(domain: "validate", code: 0, userInfo: [NSLocalizedDescriptionKey: "No callback given!"])
        }
        
        let result = try self.callback(validator: self, value: value, context: context)
        
        if !result.result {
            
            self.returnError(result.errorMessage ?? "")
        }
        
        return result.result
    }
}
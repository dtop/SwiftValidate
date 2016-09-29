//
//  ValidatorCallback.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorCallback: BaseValidator, ValidatorProtocol {
    
    /// nil is allowed
    public var allowNil: Bool = true
    
    /// Holds the callback
    public var callback: ((ValidatorCallback, Any?, [String : Any?]?) throws -> (result: Bool, errorMessage: String?))!
    
    /**
     Init
     
     - parameter initializer: initializer for easy setup
     
     - returns: the instance
     */
    required public init( _ initializer: (ValidatorCallback) -> () = { _ in }) {
        
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
    public override func validate<T: Any>(_ value: T?, context: [String: Any?]?) throws -> Bool {
        
        // reset errors
        self.emptyErrors()
        
        if nil == self.callback {
            throw NSError(domain: "validate", code: 0, userInfo: [NSLocalizedDescriptionKey: "No callback given!"])
        }
        
        if self.allowNil && nil == value {
            return true
        }
        
        let result = try self.callback(self, value, context)
        
        if !result.result {
            
            _ = self.returnError(error: result.errorMessage ?? "")
        }
        
        return result.result
    }
}

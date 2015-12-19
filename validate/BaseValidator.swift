//
//  BaseValidator.swift
//  validator
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

/**
 * Can be the base of a validation class
 *
 * DO NOT instanciate directly
 */
public class _BaseValidator: ValidationAwareProtocol {
    
    public var errors: [String] = []
    
    /**
     Validates the value
     
     - parameter value:   teh value
     - parameter context: the context
     
     - throws validation errors
     
     - returns: true on success
     */
    public func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        preconditionFailure("override me")
    }
    
    /**
     Easy form for storing an error and returning false
     
     - parameter error: the error
     
     - returns: false
     */
    func returnError(error: String) -> Bool {
        
        self.errors.append(error)
        return false
    }
}

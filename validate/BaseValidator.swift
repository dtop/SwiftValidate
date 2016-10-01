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
public class BaseValidator: ValidationAwareProtocol {
    
    public var errors: [String] = []
    
    /**
     Validates the value
     
     - parameter value:   teh value
     - parameter context: the context
     
     - throws validation errors
     
     - returns: true on success
     */
    public func validate<T: Any>(_ value: T?, context: [String: Any?]?) throws -> Bool {
        preconditionFailure("override me")
    }
    
    /**
     Easy form for storing an error and returning false
     
     - parameter error: the error
     
     - returns: false
     */
    func returnError(error: String) -> Bool {
        
        if !error.isEmpty {
        
            self.errors.append(error)
        }
        
        return false
    }
    
    /**
     Empties the errors for the next run
     */
    func emptyErrors() {
        
        self.errors = [String]()
    }
}

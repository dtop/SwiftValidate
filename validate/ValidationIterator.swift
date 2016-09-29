//
//  ValidationIterator.swift
//  validate
//
//  Created by Danilo Topalovic on 25.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidationIterator {
    
    /// result the iterator processes for unknown keys (no chain registered)
    public var resultForUnknownKeys: Bool = false
    
    /// error message if no validation is given for the key
    public var errorNoFieldRegisteredForValidator: String = NSLocalizedString("The field %@ can not be validated - no validation registered", comment: "ValidationIterator - No Chain registered")
    
    /// holds the validator chain for each field
    private var chains = [String: ValidatorChain]()
    
    /// errors occured
    private var errors = [String: [String]]()
    
    /**
     Initializes the iterator
     
     - returns: the instance
     */
    required public init( _ initializer: (ValidationIterator) -> () = { _ in }) {
        
        initializer(self)
    }
    
    /**
     Registeres a chain with a key to be validated against a 
     value with the same key
     
     - parameter chain: the chain
     - parameter key:   the key
     */
    public func register(chain: ValidatorChain, forKey key: String) {
        
        self.chains[key] = chain
    }
    
    /**
     Registers one chain for multiple keys
     
     - parameter chain: the chain
     - parameter keys:  the array of keys
     */
    public func register(chain: ValidatorChain, forKeys keys: [String]) {
        
        for key in keys {
            
            self.register(chain: chain, forKey: key)
        }
    }
    
    /**
     Validates an key / value dictionary against the preregistered
     validator chain for the equal keys
     
     - parameter values: the dictionary to be validated
     
     - returns: true if validation has completely passed
     */
    public func validate(_ values: [String: Any?]) -> Bool {
        
        /// the result that will be returned
        var result: Bool = values.count > 0
        
        //reset errors
        self.errors = [String: [String]]()
        
        for (key, value) in values {
            
            if let chain = self.chains[key] {
                
                // validating value according to registered chain
                let validatorResult = self.validate(value, withKey: key, andWithChain: chain, andContext: values)
                result = result && validatorResult
                continue
            }
            
            if false == self.resultForUnknownKeys {
                
                // no chain registered for the given value
                self.errors[key] = [String(format: self.errorNoFieldRegisteredForValidator, key)]
                result = result && false
            }
        }
        
        return result
    }
    
    /**
     Returns all errors
     
     - returns: all errors
     */
    public func getAllErrors() -> [String: [String]] {
        
        return self.errors
    }
    
    /**
     Returns the errors for the given key
     
     - parameter key: the key
     
     - returns: the errors
     */
    public func getErrorsFor(key: String) -> [String]? {
        
        if let errors = self.errors[key] {
            
            return errors
        }
        
        return nil
    }
    
    /**
     Returns if the given key is in error
     
     - parameter key: the key
     
     - returns: true if in error
     */
    public func isInError(key: String) -> Bool {
        
        if let _ = self.errors[key] {
            return true
        }
        
        return false
    }
    
    /**
     Validates the value against the chain
     
     - parameter value:   the value
     - parameter key:     the key
     - parameter chain:   the chain
     - parameter context: the context (all values)
     
     - returns: true if ok
     */
    private func validate(_ value: Any?, withKey key: String, andWithChain chain: ValidatorChain, andContext context: [String: Any?]?) -> Bool {
        
        if !chain.validate(value, context: context) {
         
            self.errors[key] = chain.errors
            return false
        }
        
        return true
    }
}

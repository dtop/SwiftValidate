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
    required public init(@noescape _ initializer: (ValidationIterator) -> () = { _ in }) {
        
        initializer(self)
    }
    
    /**
     Registeres a chain with a key to be validated against a 
     value with the same key
     
     - parameter chain: the chain
     - parameter key:   the key
     */
    public func registerChain(chain: ValidatorChain, forKey key: String) {
        
        self.chains[key] = chain
    }
    
    /**
     Registers one chain for multiple keys
     
     - parameter chain: the chain
     - parameter keys:  the array of keys
     */
    public func registerChain(chain: ValidatorChain, forKeys keys: [String]) {
        
        for key in keys {
            
            self.registerChain(chain, forKey: key)
        }
    }
    
    /**
     Validates an key / value dictionary against the preregistered
     validator chain for the equal keys
     
     - parameter values: the dictionary to be validated
     
     - returns: true if validation has completely passed
     */
    public func validate(values: [String: Any?]) -> Bool {
        
        /// the result that will be returned
        var result: Bool = values.count > 0
        
        //reset errors
        self.errors = [String: [String]]()
        
        for (key, value) in values {
            
            if let chain = self.chains[key] {
                
                // validating value according to registered chain
                let validatorResult = self.validateValue(value, withKey: key, andWithChain: chain, andContext: values)
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
    public func getErrorsFor(key key: String) -> [String]? {
        
        if let errors = self.errors[key] {
            
            return errors
        }
        
        return nil
    }
    
    /**
     Validates the value against the chain
     
     - parameter value:   the value
     - parameter key:     the key
     - parameter chain:   the chain
     - parameter context: the context (all values)
     
     - returns: true if ok
     */
    private func validateValue(value: Any?, withKey key: String, andWithChain chain: ValidatorChain, andContext context: [String: Any?]?) -> Bool {
        
        if !chain.validate(value, context: context) {
         
            self.errors[key] = chain.errors
            return false
        }
        
        return true
    }
}

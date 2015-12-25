//
//  ValidatorChain.swift
//  validator
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorChain {
    
    /// holds the validators
    var validators: [ValidationAwareProtocol] = []
    
    /// holds the occured errors or thrown exceptions
    var errors: [String] = []
    
    /// should stop on first error
    var stopOnFirstError: Bool = false
    
    /// should stop on exception
    var stopOnException: Bool = false
    
    /**
     Inits the validator chain
     
     - returns: the instance
     */
    init(@noescape _ initializer: ValidatorChain -> () = { _ in }) {
        
        initializer(self)
    }
    
    /**
     Validates the entire chain
     
     - parameter value:   the value to validate
     - parameter context: the validation context
     
     - returns: true if correct
     */
    func validate<T: Any>(value: T?, context: [String: Any?]?) -> Bool {
        
        var result = true
        
        for validator in self.validators {
            
            do {
                
                let isValid = try validator.validate(value, context: context)
                
                if !isValid {
                    
                    self.addErrors(validator.errors)
                }
                
                if self.stopOnFirstError && !isValid {
                    
                    return false
                }
                
                result = result && isValid
            } catch let error as NSError {
                
                self.addErrors([error.localizedDescription])
                if self.stopOnException {
                    
                    return false
                }
                
                result = false
            }
        }
        
        return result
    }
    
    /**
     Adds a validator to the list of validators
     
     - parameter validator: the validator
     */
    func addValidator(validator: ValidationAwareProtocol) {
        
        self.validators.append(validator)
    }
    
    // MARK: - private functions -
    
    /**
    Adds errors to the array of errors
    
    - parameter errors: the errors
    */
    private func addErrors(errors: [String]) {
        
        for error in errors {
            
            self.errors.append(error)
        }
    }
}

infix operator <~~ { associativity left precedence 100 }

func <~~ (left: ValidatorChain, right: ValidationAwareProtocol) -> ValidatorChain {
    
    left.addValidator(right)
    return left
}

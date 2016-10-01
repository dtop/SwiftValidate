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
    public var errors: [String] = []
    
    /// should stop on first error
    public var stopOnFirstError: Bool = false
    
    /// should stop on exception
    public var stopOnException: Bool = false
    
    /**
     Inits the validator chain
     
     - returns: the instance
     */
    public init( _ initializer: (ValidatorChain) -> () = { _ in }) {
        
        initializer(self)
    }
    
    /**
     Validates the entire chain
     
     - parameter value:   the value to validate
     - parameter context: the validation context
     
     - returns: true if correct
     */
    public func validate<T: Any>(_ value: T?, context: [String: Any?]?) -> Bool {
        
        var result = true
        self.errors = [String]()
        
        for validator in self.validators {
            
            do {
                
                let isValid = try validator.validate(value, context: context)
                
                if !isValid {
                    
                    self.addErrors(errors: validator.errors)
                }
                
                if self.stopOnFirstError && !isValid {
                    
                    return false
                }
                
                result = result && isValid
            } catch let error as NSError {
                
                self.addErrors(errors: [error.localizedDescription])
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
    public func add(validator: ValidationAwareProtocol) {
        
        self.validators.append(validator)
    }
    
    /**
     Returns a validator by index for editing
     
     - parameter index: the index
     
     - returns: the validator or nil
     */
    public func get<T>(validatorWithIndex index: Int) -> T? {
        
        if self.validators.count < index {
            return nil
        }
        
        if let validator = self.validators[index] as? T {
            
            return validator
        }
        
        return nil
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

precedencegroup AsignmentPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator <~~ : AsignmentPrecedence

@discardableResult
public func <~~ (left: ValidatorChain, right: ValidationAwareProtocol) -> ValidatorChain {
    
    left.add(validator: right)
    return left
}

//
//  ValidatorRequired.swift
//  validate
//
//  Created by Danilo Topalovic on 25.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorRequired: BaseValidator, ValidatorProtocol {
    
    /// custom callback that determines satisfaction of requirement
    var requirementCondition: ((value: Any?, context: [String: Any?]?) -> Bool)?
    
    /// the error message
    var errorMessage: String = NSLocalizedString("This value is required. Please enter a value", comment: "ValidatorRequired - No value")
    
    /**
     Inits the validator
     
     - returns: the instance
     */
    public required init(@noescape _ initializer: ValidatorRequired -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Validates if the given requirement condition fits or
     of none is given if the value is not nil
     
     - parameter value:   the value to validate
     - parameter context: teh context
     
     - throws: validation errors
     
     - returns: true if ok
     */
    public override func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        return (nil != self.requirementCondition && self.requirementCondition!(value: value, context: context)) || nil != value
    }
}

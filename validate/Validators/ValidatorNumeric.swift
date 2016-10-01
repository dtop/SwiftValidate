//
//  ValidatorNumeric.swift
//  validator
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorNumeric: BaseValidator, ValidatorProtocol {
    
    /// nil is allowed
    public var allowNil: Bool = true
    
    /// Holds if the number can be a string representation
    public var allowString: Bool = true
    
    /// Holds if we accept floating point numbers
    public var allowFloatingPoint = true
    
    /// error message not numeric
    public var errorMessageNotNumeric = NSLocalizedString("Please enter avalid number", comment: "error message not numeric")
    
    /**
     inits
     
     - returns: the instance
     */
    required public init( _ initializer: (ValidatorNumeric) -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Validates the value
     
     - parameter value:   the value
     - parameter context: the context (if any)
     
     - throws: validation errors
     
     - returns: true on success
     */
    override public func validate<T: Any>(_ value: T?, context: [String: Any?]?) throws -> Bool {
        
        self.emptyErrors()
        
        if self.allowNil && nil == value {
            return true
        }
        
        if let strVal: String = value as? String {
            
            if !self.allowString {
                return self.returnError(error: self.errorMessageNotNumeric)
            }
            
            if self.canBeInt(number: strVal) || (self.allowFloatingPoint && self.canBeFloat(number: strVal)) {
                return true
            }
            
            return self.returnError(error: self.errorMessageNotNumeric)
        }
        
        if let _ = value as? Int {
            return true
        }
        
        if self.allowFloatingPoint {
            
            if let _ = value as? Double {
                
                return true
            }
        }
        
        return self.returnError(error: self.errorMessageNotNumeric)
    }
    
    /**
     Tests if the number could be an int
     
     - parameter number: the number as string
     
     - returns: true if possible
     */
    private func canBeInt(number: String) -> Bool {
        
        guard let _ = Int(number) else {
            return false
        }
        
        return true
    }
    
    /**
     Tests if the number could be a double
     
     - parameter number: the number as string
     
     - returns: true if possible
     */
    private func canBeFloat(number: String) -> Bool {
        
        guard let _ = Double(number) else {
            return false
        }
        
        return true
    }
}

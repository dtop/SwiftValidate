//
//  ValidatorNumeric.swift
//  validator
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

class ValidatorNumeric: _BaseValidator, ValidatorProtocol {
    
    var errorMessageNotNumeric = NSLocalizedString("Please enter avalid number", comment: "error message not numeric")
    
    /// Holds if the number can be a string representation
    var canBeString: Bool = true
    
    /// Holds if we accept floating point numbers
    var allowFloatingPoint = true
    
    /**
     inits
     
     - returns: the instance
     */
    required init(@noescape _ initializer: ValidatorNumeric -> () = { _ in }) {
        
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
    override func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        if let strVal: String = value as? String {
            
            if !self.canBeString {
                return self.returnError(self.errorMessageNotNumeric)
            }
            
            if self.canBeInt(strVal) || (self.allowFloatingPoint && self.canBeFloat(strVal)) {
                return true
            }
            
            return self.returnError(self.errorMessageNotNumeric)
        }
        
        if let _ = value as? Int {
            return true
        }
        
        if self.allowFloatingPoint {
            
            if let _ = value as? Double {
                
                return true
            }
        }
        
        return self.returnError(self.errorMessageNotNumeric)
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

//
//  ValidatorStrLen.swift
//  validator
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

/**
 * Validates the strlen of a string
 */
class ValidatorStrLen: BaseValidator, ValidatorProtocol {
    
    /// error if no string
    var errorMessageNotAString = NSLocalizedString("the given value was no string", comment: "ValidatorStrLen - error message no string")
    
    /// error if too small
    var errorMessageTooSmall = NSLocalizedString("please enter at least %i characters", comment: "ValidatorStrLen - error message size too small")
    
    /// error if too large
    var errorMessageTooLarge = NSLocalizedString("please enter %i or less characters", comment: "ValidatorStrLen - error message size too large")
    
    /// maximum string lenght
    var maxLength: Int = 30
    
    // minimum string length
    var minLength: Int = 3
    
    /**
     inits
     
     - returns: the instance
     */
    required init(@noescape _ initializer: ValidatorStrLen -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Validates the string length of a string against min or max
     
     - parameter value:   teh value to validate
     - parameter context: the context
     
     - throws: validation errors
     
     - returns: true if ok
     */
    override func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        if let val: String = value as? String {
            
            let tooLong  = val.characters.count > self.maxLength
            let tooShort = val.characters.count < self.minLength
            
            if tooLong {
                
                self.errors.append(self.stuffString(self.errorMessageTooLarge, num: self.maxLength))
            }
            
            if tooShort {
                
                self.errors.append(self.stuffString(self.errorMessageTooSmall, num: self.minLength))
            }
            
            return !tooShort && !tooLong
        }
        
        return self.returnError(self.errorMessageNotAString)
    }
    
    /**
     Stuffs the error string with values
     
     - parameter str: the string
     - parameter num: the value
     
     - returns: teh resulting stirng
     */
    private func stuffString(str: String, num: Int) -> String {
        
        return String(format: str, num)
    }
}

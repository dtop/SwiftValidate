//
//  ValidatorAlnum.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorAlnum: _BaseValidator, ValidatorProtocol {
    
    /// allow only ascii chars
    var allowEmpty: Bool = false
    
    /// error message not alnum
    var errorMessageStringNotAlnum: String = NSLocalizedString("The String contains illegal characters", comment: "ValidatorAlnum - String not alnum")
    
    /// error message no string
    var errorNoString: String = NSLocalizedString("The entered value was no string", comment: "ValidatorAlnum - String no string")
    
    /**
     Required init
     
     - parameter initializer: the initializer callback
     
     - returns: the instance
     */
    required public init(@noescape _ initializer: ValidatorAlnum -> ()) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Validates if the string is alnum
     
     - parameter value:   the string
     - parameter context: context
     
     - throws: validation errors
     
     - returns: true if alnum
     */
    override public func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        let charSet = NSCharacterSet.alphanumericCharacterSet()
        
        if let strVal = value as? String {
            
            if self.allowEmpty && strVal.isEmpty {
                return true
            }
            
            if let _ = strVal.rangeOfCharacterFromSet(charSet.invertedSet) {
             
                return self.returnError(self.errorMessageStringNotAlnum)
            }
            
            return true
        }
        
        return self.returnError(self.errorNoString)
    }
}
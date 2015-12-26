//
//  ValidatorAlnum.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorAlnum: BaseValidator, ValidatorProtocol {
    
    /// allow nil values
    public var allowNil: Bool = true
    
    /// allow only ascii chars
    public var allowEmpty: Bool = false
    
    /// error message not alnum
    public var errorMessageStringNotAlnum: String = NSLocalizedString("The String contains illegal characters", comment: "ValidatorAlnum - String not alnum")
    
    /// error message no string
    public var errorNoString: String = NSLocalizedString("The entered value was no string", comment: "ValidatorAlnum - String no string")
    
    /**
     Required init
     
     - parameter initializer: the initializer callback
     
     - returns: the instance
     */
    required public init(@noescape _ initializer: ValidatorAlnum -> () = { _ in }) {
        
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
        
        if self.allowNil && nil == value {
            return true
        }
        
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
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to validate chars in string incompatible value"])
    }
}

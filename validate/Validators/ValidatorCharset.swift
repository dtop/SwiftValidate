//
//  ValidatorCharset.swift
//  SwiftValidate
//
//  Created by Danilo Topalovic on 27.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorCharset: BaseValidator, ValidatorProtocol {
    
    /// allow nil values
    public var allowNil: Bool = true
    
    /// allow only ascii chars
    public var allowEmpty: Bool = false
    
    // the charset to validate against
    public var charset: CharacterSet!
    
    /// error message not alnum
    public var errorMessageStringDoesNotFit: String = NSLocalizedString("The String contains illegal characters", comment: "ValidatorCharset - String not alnum")
    
    /**
     Easy init
     
     - returns: the instance
     */
    public required init( _ initializer: (ValidatorCharset) -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Validates the given string against the given charset
     
     - parameter value:   the value to match
     - parameter context: the context
     
     - throws: validation errors
     
     - returns: true if ok
     */
    public override func validate<T: Any>(_ value: T?, context: [String: Any?]?) throws -> Bool {
        
        // reset errors
        self.emptyErrors()
        
        if nil == self.charset {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "no chaset given"])
        }
        
        if self.allowNil && nil == value {
            return true
        }
        
        if let strVal = value as? String {
            
            if self.allowEmpty && strVal.isEmpty {
                return true
            }
            
            if let _ = strVal.rangeOfCharacter(from: self.charset.inverted) {
                
                return self.returnError(error: self.errorMessageStringDoesNotFit)
            }
            
            return true
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to validate chars in string incompatible value"])
    }
}

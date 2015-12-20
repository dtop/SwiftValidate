//
//  ValidatorSmallerThan.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorSmallerThan<TYPE: SignedNumberType>: ValidatorProtocol {
    
    /// the value to compare against
    var max: TYPE = 0
    
    /// number inclusive?
    var inclusive: Bool = true
    
    /// error message for invalid type (not a number)
    var errorMessageInvalidType: String = NSLocalizedString("the given type was invalid", comment: "ValidatorSmallerThan - invalid type")
    
    /// error message if value is bigger than expected
    var errorMessageNotSmallerThan: String = NSLocalizedString("the given value was not smaller than %@", comment: "ValidatorSmallerThan - value too big")
    
    /// the errors
    private var _err: [String] = []
    
    /// the errors (if any)
    public var errors: [String] {
        return self._err
    }
    
    //MARK: comparision functions
    
    let compareExclusive = { (alpha: TYPE, bravo: TYPE ) -> Bool in return alpha > bravo }
    let compareInclusive = { (alpha: TYPE, bravo: TYPE ) -> Bool in return alpha >= bravo }
    
    //MARK: methods
    
    /**
    Easy init
    
    - returns: the instance
    */
    required public init(@noescape _ initializer: ValidatorSmallerThan -> () = { _ in }) {
        
        initializer(self)
    }
    
    /**
     Validates if the given value is smaller than a predefined one
     
     - parameter value:   the value to compare
     - parameter context: the context (unused)
     
     - throws: validation errors
     
     - returns: true if ok
     */
    public func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        if let strVal = value as? String {
            
            return try self.compareAsString(strVal)
        }
        
        if let myVal = value as? TYPE {
            
            return self.compareAsNumber(myVal)
        }
        
        self._err.append(self.errorMessageInvalidType)
        return false
    }
    
    //MARK: - private functions -
    
    func compareAsString(value: String) throws -> Bool {
        
        if let numVal = Double(value) {
            
            guard let max = NumberConverter<TYPE>.toDouble(self.max) else {
                return false
            }
            
            let validator = ValidatorSmallerThan<Double>() {
                $0.max = max
                $0.inclusive = self.inclusive
            }
            
            let result = try validator.validate(numVal, context: nil)
            if !result {
                self._err.append(String(format: self.errorMessageNotSmallerThan, String(self.max)))
            }
            
            return result
        }
        
        self._err.append(self.errorMessageInvalidType)
        return false
    }
    
    /**
     Compares the number as is
     
     - parameter value: the number
     
     - returns: true if ok
     */
    func compareAsNumber(value: TYPE) -> Bool {
        
        let result = (self.inclusive) ? self.compareInclusive(self.max, value) : self.compareExclusive(self.max, value)
        if !result {
            
            self._err.append(String(format: self.errorMessageNotSmallerThan, String(self.max)))
        }
        
        return result
    }
}

//
//  ValidatorBetween.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorBetween<TYPE: SignedNumberType>: ValidatorProtocol {
    
    /// allows the value to be nil
    var allowNil: Bool = true
    
    /// allows the value as string
    var allowString: Bool = true
    
    // minimal value
    var minValue: TYPE = 0
    
    // maximal value
    var maxValue: TYPE = 0
    
    // comparision inclusive with min
    var minInclusive = true
    
    // comparision inclusive with max
    var maxInclusive = true
    
    /// error message for invalid type (not a number)
    var errorMessageInvalidType: String = NSLocalizedString("the given type was invalid", comment: "ValidatorBetween - invalid type")
    
    /// error message if not between
    var errorMessageNotBetween: String = NSLocalizedString("the given number is not between the presets", comment: "ValidatorBetween - not between")
    
    /// the errors
    private var _err: [String] = []
    
    /// the errors (if any)
    public var errors: [String] {
        return self._err
    }
    
    // MARK: comparision closures
    
    let compareExclusive = { (alpha: TYPE, bravo: TYPE ) -> Bool in return alpha > bravo }
    let compareInclusive = { (alpha: TYPE, bravo: TYPE ) -> Bool in return alpha >= bravo }
    
    // MARK: methods
    
    /**
    Inits
    
    - returns: the instance
    */
    required public init(@noescape _ initializer: ValidatorBetween -> () = { _ in }) {
        
        initializer(self)
    }
    
    /**
     Validates the input if it is between the predefined values
     
     - parameter value:   the value
     - parameter context: the context
     
     - throws: comparision errors
     
     - returns: true if ok
     */
    public func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        if self.allowNil && nil == value {
            return true
        }
        
        if let strVal = value as? String {
            
            if !self.allowString {
                
                self._err.append(self.errorMessageInvalidType)
                return false
            }
            
            return try self.compareAsString(strVal)
        }
        
        if let myNum: TYPE = value as? TYPE {
            
            let leftOk = (self.minInclusive) ? self.compareInclusive(myNum, self.minValue) : self.compareExclusive(myNum, self.minValue)
            let rightOk = (self.maxInclusive) ? self.compareInclusive(self.maxValue, myNum) : self.compareExclusive(self.maxValue, myNum)
            
            if leftOk && rightOk {
                return true
            }
            
            self._err.append(self.errorMessageNotBetween)
            return false
        }
        
        self._err.append(self.errorMessageInvalidType)
        return false
    }
    
    /**
     Does the comparision if the given value is a string
     
     - parameter value: the value
     
     - throws: ---
     
     - returns: true if ok
     */
    private func compareAsString(value: String) throws -> Bool {
        
        if let numVal = Double(value) {
            
            guard let minVal = NumberConverter<TYPE>.toDouble(self.minValue) else {
                return false
            }
            
            guard let maxVal = NumberConverter<TYPE>.toDouble(self.maxValue) else {
                return false
            }
            
            let comparator = ValidatorBetween<Double>() {
                $0.allowString = true
                $0.minValue = minVal
                $0.maxValue = maxVal
                $0.minInclusive = self.minInclusive
                $0.maxInclusive = self.maxInclusive
            }
            
            return try comparator.validate(numVal, context: nil)
        }
        
        self._err.append(self.errorMessageInvalidType)
        return false
    }
}

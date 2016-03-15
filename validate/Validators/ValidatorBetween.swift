//
//  ValidatorBetween.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorBetween<TYPE: SignedNumberType>: ValidatorProtocol, ValidationAwareProtocol {
    
    /// allows the value to be nil
    public var allowNil: Bool = true
    
    /// allows the value as string
    public var allowString: Bool = true
    
    // minimal value
    public var minValue: TYPE = 0
    
    // maximal value
    public var maxValue: TYPE = 0
    
    // comparision inclusive with min
    public var minInclusive = true
    
    // comparision inclusive with max
    public var maxInclusive = true
    
    /// error message for invalid type (not a number)
    public var errorMessageInvalidType: String = NSLocalizedString("the given type was invalid", comment: "ValidatorBetween - invalid type")
    
    /// error message if not between
    public var errorMessageNotBetween: String = NSLocalizedString("the given number is not between the presets", comment: "ValidatorBetween - not between")
    
    /// the errors
    private var _err: [String] = []
    
    /// the errors (if any)
    public var errors: [String] {
        return self._err
    }
    
    // MARK: comparision closures
    
    private let compareExclusive = { (alpha: TYPE, bravo: TYPE ) -> Bool in return alpha > bravo }
    private let compareInclusive = { (alpha: TYPE, bravo: TYPE ) -> Bool in return alpha >= bravo }
    
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
        
        self._err = [String]()
        
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
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid type - not compatible to string or SignedNumberType"])
    }
    
    /**
     Does the comparision if the given value is a string
     
     - parameter value: the value
     
     - throws: ---
     
     - returns: true if ok
     */
    private func compareAsString(value: String) throws -> Bool {
        
        if let numVal = Double(value) {
            
            guard let minVal = NumberConverter<TYPE>.toDouble(self.minValue), let maxVal = NumberConverter<TYPE>.toDouble(self.maxValue) else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "internal error - could not convert to double"])
            }
            
            let comparator = ValidatorBetween<Double>() {
                $0.allowString = true
                $0.minValue = minVal
                $0.maxValue = maxVal
                $0.minInclusive = self.minInclusive
                $0.maxInclusive = self.maxInclusive
            }
            
            let result = try comparator.validate(numVal, context: nil)
            if !result {
                self._err = comparator.errors
            }
            
            return result
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid type - not compatible to string or SignedNumberType"])
    }
}

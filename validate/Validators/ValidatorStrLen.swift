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
public class ValidatorStrLen: BaseValidator, ValidatorProtocol {
    
    /// allow nil
    public var allowNil = true
    
    /// error if too small
    public var errorMessageTooSmall = NSLocalizedString("please enter at least %i characters", comment: "ValidatorStrLen - error message size too small")
    
    /// error if too large
    public var errorMessageTooLarge = NSLocalizedString("please enter %i or less characters", comment: "ValidatorStrLen - error message size too large")
    
    /// maximum string lenght
    public var maxLength: Int = 30
    
    // minimum string length
    public var minLength: Int = 3
    
    /// minimum length inclusive
    public var minInclusive = true
    
    /// maximum length inclusive (<= instead of <)
    public var maxInclusive = true
    
    private let compareGreater = {(alpha: Int, bravo: Int) -> Bool in return alpha > bravo}
    private let compareGreaterEqual = {(alpha: Int, bravo: Int) -> Bool in return alpha >= bravo}
    
    /**
     inits
     
     - returns: the instance
     */
    required public init( _ initializer: (ValidatorStrLen) -> () = { _ in }) {
        
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
    override public func validate<T: Any>(_ value: T?, context: [String: Any?]?) throws -> Bool {
        
        // reset errors
        self.emptyErrors()
        
        if self.allowNil && nil == value {
            return true
        }
        
        // real string
        if let val: String = value as? String {
            
            let length = val.characters.count
            
            let notTooLong  = self.measure(maximumLength: length)
            let notTooShort = self.measure(minimumLength: length)
            
            return notTooLong && notTooShort
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to measure string length of string incompatible value"])
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
    
    /**
     Measures the maximum
     
     - parameter length: the str length
     
     - returns: true if ok
     */
    private func measure(minimumLength length: Int) -> Bool {
        
        let result = (self.maxInclusive) ? self.compareGreaterEqual(self.maxLength, length) : self.compareGreater(self.maxLength, length)
        if !result {
            
            return self.returnError(error: self.stuffString(str: self.errorMessageTooLarge, num: self.maxLength))
        }
        
        return true
    }
    
    /**
     Measures the minimum
     
     - parameter length: the str length
     
     - returns: true if ok
     */
    private func measure(maximumLength length: Int) -> Bool {
        
        let result = (self.minInclusive) ? self.compareGreaterEqual(length, self.minLength) : self.compareGreater(length, self.minLength)
        if !result {
            
            return self.returnError(error: self.stuffString(str: self.errorMessageTooSmall, num: self.minLength))
        }
        
        return true
    }
}

//
//  ValidatorSmallerThan.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorSmallerThan<TYPE: SignedNumber>: ValidatorProtocol, ValidationAwareProtocol {
    
    /// nil is allowed
    public var allowNil: Bool = true
    
    /// the value to compare against
    public var max: TYPE = 0
    
    /// number inclusive?
    public var inclusive: Bool = true
    
    /// error message for invalid type (not a number)
    public var errorMessageInvalidType: String = NSLocalizedString("the given type was invalid", comment: "ValidatorSmallerThan - invalid type")
    
    /// error message if value is bigger than expected
    public var errorMessageNotSmallerThan: String = NSLocalizedString("the given value was not smaller than %@", comment: "ValidatorSmallerThan - value too big")
    
    /// the errors
    private var _err: [String] = []
    
    /// the errors (if any)
    public var errors: [String] {
        return self._err
    }
    
    //MARK: comparision functions
    
    private let comparator = { (alpha: TYPE, bravo: TYPE, comp: (TYPE, TYPE) -> Bool) -> Bool in return comp(alpha, bravo) }
    
    //MARK: methods
    
    /**
    Easy init
    
    - returns: the instance
    */
    required public init(_ initializer: (ValidatorSmallerThan) -> () = { _ in }) {
        
        initializer(self)
    }
    
    /**
     Validates if the given value is smaller than a predefined one
     
     - parameter value:   the value to compare
     - parameter context: the context (unused)
     
     - throws: validation errors
     
     - returns: true if ok
     */
    public func validate<T: Any>(_ value: T?, context: [String: Any?]?) throws -> Bool {
        
        self._err = [String]()
        
        if self.allowNil && nil == value {
            return true
        }
        
        if let strVal = value as? String {
            
            return try self.compareAsString(value: strVal)
        }
        
        if let myVal = value as? TYPE {
            
            return self.compareAsNumber(value: myVal)
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid type - not compatible to string or SignedNumberType"])
    }
    
    //MARK: - private functions -
    
    private func compareAsString(value: String) throws -> Bool {
        
        if let numVal = Double(value) {
            
            guard let max = NumberConverter<TYPE>.toDouble(value: self.max) else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "internal error - could not convert to double"])
            }
            
            let validator = ValidatorSmallerThan<Double>() {
                $0.max = max
                $0.inclusive = self.inclusive
            }
            
            let result = try validator.validate(numVal, context: nil)
            if !result {
                self._err.append(String(format: self.errorMessageNotSmallerThan, String(describing: self.max)))
            }
            
            return result
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid type - not compatible to string or SignedNumberType"])
    }
    
    /**
     Compares the number as is
     
     - parameter value: the number
     
     - returns: true if ok
     */
    private func compareAsNumber(value: TYPE) -> Bool {
        
        let result = (self.inclusive) ? self.comparator(value, self.max, <=) : self.comparator(value, self.max, <)
        
        if !result {
            
            self._err.append(String(format: self.errorMessageNotSmallerThan, String(describing: self.max)))
        }
        
        return result
    }
}

//
//  ValidatorInArray.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorInArray<TYPE: Equatable>: ValidatorProtocol, ValidationAwareProtocol {
    
    /// nil value is allowed and true
    public var allowNil: Bool = true
    
    /// possible values
    public var array: [TYPE] = []
    
    public var errorMessageItemIsNotContained: String = NSLocalizedString("the given value is not contained in the possibilities", comment: "ValidatorInArray - Not contained")
    
    /// the errors
    private var _err: [String] = []
    
    /// the errors (if any)
    public var errors: [String] {
        return self._err
    }
    
    /**
     Easy init
     
     - parameter initializer: the initializer
     
     - returns: the instance
     */
    required public init( _ initializer: (ValidatorInArray) -> () = { _ in }) {
    
        initializer(self)
    }
    
    /**
     Validates if the given value is contained in a predefined array
     
     - parameter value:   the value
     - parameter context: the context (unused)
     
     - throws: comparison errors
     
     - returns: true if contained
     */
    public func validate<T: Any>(_ value: T?, context: [String: Any?]?) throws -> Bool {
       
        // reset errors
        self._err = [String]()
        
        if self.allowNil && value == nil {
            return true
        }

        if let myType = value as? TYPE {
            
            let result = self.array.filter({$0 == myType}).count > 0
            if !result {
                
                self._err.append(self.errorMessageItemIsNotContained)
            }
            
            return result
        }
        
        // if TYPE not String but Value
        if let strVal = value as? String {
            
            return try self.compareDifferentTypesAsString(value: strVal)
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid type - not compatible to string or SignedNumberType"])
    }
    
    //MARK: - private functions -
    
    /**
    Convertes the arrays members to string and does a string comparison
    
    - parameter value: the value to compare
    
    - throws: comparision errors
    
    - returns: true if contained
    */
    private func compareDifferentTypesAsString(value: String) throws -> Bool {
        
        // convert everything to string
        
        var arr: [String] = []
        for item in self.array {
            
            arr.append(String(describing: item))
        }
        
        let validator = ValidatorInArray<String>() {
            $0.array = arr
        }
        
        let result = try validator.validate(value, context: nil)
        
        if !result {
            
            self._err.append(self.errorMessageItemIsNotContained)
        }
        
        return result
    }
}

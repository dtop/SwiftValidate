//
//  ValidatorEmpty.swift
//  validator
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

/**
 * Validates on emptynes
 */
public class ValidatorEmpty: BaseValidator, ValidatorProtocol {
    
    /// can the value be nil?
    public var allowNil: Bool = false
    
    /// this error message
    public var errorMessage: String = NSLocalizedString("Value was Empty", comment: "ValidatorEmpty - Error String")
    
    /**
     inits
     
     - parameter initializer: the initializer callback
     
     - returns: the instance
     */
    required public init( _ initializer: (ValidatorEmpty) -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Validates
     
     - parameter value:   the value
     - parameter context: the context
     
     - throws: validation erorrs
     
     - returns: true on correctness
     */
    override public func validate<T: Any>(_ value: T?, context: [String: Any?]?) throws -> Bool {
        
        // reset errors
        self.emptyErrors()
        
        if self.allowNil && nil == value {
            return true
        }
        
        if let val: String = value as? String {
            
            if val.isEmpty {
                
                return self.returnError(error: self.errorMessage)
            }
            
            return true
        }
        
        return self.returnError(error: self.errorMessage)
    }
}

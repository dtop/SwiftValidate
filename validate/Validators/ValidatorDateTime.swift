//
//  ValidatorDateTime.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorDateTime: BaseValidator, ValidatorProtocol {
    
    /// nil is allowed
    public var allowNil: Bool = true
    
    /// Holds the date format to interpret with
    public var dateFormat: String = "yyyy-MM-dd HH:mm:ss"
    
    /// Error string for illegal type
    public var errorMessageInvalidDate: String = NSLocalizedString("the given type is not compatible to NSDate", comment: "ValidatorDateTime - illegal type")
    
    /**
     Inits the class
     
     - parameter initializer: the custom changes
     
     - returns: the instance
     */
    required public init( _ initializer: (ValidatorDateTime) -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Checks if the given date is valid
     
     - parameter value:   teh date value
     - parameter context: the context (unused)
     
     - throws: validation errors (unused)
     
     - returns: true if ok
     */
    public override func validate<T: Any>(_ value: T?, context: [String: Any?]?) throws -> Bool {
        
        // reset errors
        self.emptyErrors()
        
        /// nothing to check if we have NSDate here
        if let _ = value as? NSDate {
            return true
        }
        
        if let strVal = value as? String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = self.dateFormat
            
            if let _ = dateFormatter.date(from: strVal) {
                return true
            }
        }
        
        return self.returnError(error: self.errorMessageInvalidDate)
    }
}

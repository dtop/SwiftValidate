//
//  ValidatorRegex.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorRegex: BaseValidator, ValidatorProtocol {
    
    /// allows a nil value
    public var allowNil: Bool = true
    
    /// the pattern to be matched against
    public var pattern: String!
    
    /// expression options
    public var options: NSRegularExpressionOptions = NSRegularExpressionOptions(rawValue: 0)
    
    /// matching options
    public var matchingOptions: NSMatchingOptions = NSMatchingOptions(rawValue: 0)
    
    /// error message
    public var errorMessageValueIsNotMatching: String = NSLocalizedString("the given value is not matching to the predefined regex", comment: "ValidatorRegex - no match")
    
    /**
     Easy init
     
     - returns: the instance
     */
    required public init(@noescape _ initializer: ValidatorRegex -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Validates the value against a given regular expression
     
     - parameter value:   the value
     - parameter context: the context (unused)
     
     - throws: validation errors
     
     - returns: true if it matches
     */
    public override func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        if nil == self.pattern {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No pattern given for matching"])
        }
        
        if self.allowNil && nil == value {
            return true
        }
        
        if let strVal = value as? String {
        
            let regex = try NSRegularExpression(pattern: self.pattern, options: self.options)
            let result = regex.numberOfMatchesInString(strVal, options: self.matchingOptions, range: NSMakeRange(0, strVal.characters.count)) > 0
            
            if !result {
                
                return self.returnError(self.errorMessageValueIsNotMatching)
            }
            
            return result
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown or nil value type to match against"])
    }
}

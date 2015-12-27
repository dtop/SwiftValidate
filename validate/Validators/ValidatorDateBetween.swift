//
//  ValidatorDateBetween.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorDateBetween: BaseValidator, ValidatorProtocol {
    
    /// allow nil
    public var allowNil: Bool = true
    
    /// minimum date
    public var min: NSDate!
    
    /// maximum date
    public var max: NSDate!
    
    /// inclusive minimum
    public var minInclusive: Bool = true
    
    /// inclusive maximum
    public var maxInclusive: Bool = true
    
    /// date formatter if string is expected
    public var dateFormatter: NSDateFormatter!
    
    /// error message if not between
    public var errorMessageNotBetween: String = NSLocalizedString("given date is not between predefined dates", comment: "ValidatorDateBetween - not between")
    
    // MARK: comparison funcs
    
    private let compareAscExclusive = { (left: NSDate, right: NSDate) -> Bool in return left.compare(right) == .OrderedDescending }
    private let compareAscInclusive = { (left: NSDate, right: NSDate) -> Bool in let result = left.compare(right); return result == .OrderedDescending || result == .OrderedSame }
    
    private let compareDescExclusive = { (left: NSDate, right: NSDate) -> Bool in return left.compare(right) == .OrderedAscending }
    private let compareDescInclusive = { (left: NSDate, right: NSDate) -> Bool in let result = left.compare(right); return result == .OrderedAscending || result == .OrderedSame }
    
    // MARK: methods
    
    /**
     Easy init
     
     - parameter initializer: initializer cb
     
     - returns: the instance
     */
    required public init(@noescape _ initializer: ValidatorDateBetween -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    public override func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        // reset errors
        self.emptyErrors()
        
        if self.allowNil && nil == value {
            return true
        }
        
        if nil == self.min || nil == self.max {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "min and/or max dates are nil"])
        }
        
        if let date = try self.parseDate(value) {
            
            let leftOk  = (self.minInclusive) ? self.compareAscInclusive(date, self.min)  : self.compareAscExclusive(date, self.min)
            let rightOk = (self.maxInclusive) ? self.compareDescInclusive(date, self.max) : self.compareDescExclusive(date, self.max)
            
            if !leftOk || !rightOk {
                
                return self.returnError(self.errorMessageNotBetween)
            }
            
            return true
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unreadable date format or datatype"])
    }
    
    // MARK: - private methods -
    
    private func parseDate(value: Any?) throws -> NSDate? {
        
        /// handle if is already NSDate
        if let myDate = value as? NSDate {
            return myDate
        }
        
        if let myString = value as? String {
            
            if nil == self.dateFormatter {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No date formatter given"])
            }
            
            return self.dateFormatter.dateFromString(myString)
        }
        
        return nil
    }
}

//
//  NumberConverter.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

internal class NumberConverter<TYPE: SignedNumber> {
    
    /**
     Tries a conversion to double
     
     - parameter value: the signed number value
     
     - returns: teh double (maybe)
     */
    class func toDouble(value: TYPE) -> Double? {
        
        if value is Int {
            return Double((value as? Int)!)
        }
        
        if value is Float {
            return Double((value as? Float)!)
        }
        
        return value as? Double
    }
}

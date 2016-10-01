//
//  ValidationAwareProtocol.swift
//  validator
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

/**
 *  Mandatory protocol for all validators
 */
public protocol ValidationAwareProtocol {
    
    /// holds the occured errors (if any)
    var errors: [String] { get }
    
    /**
     Validates the value
     
     - parameter value:   teh value
     - parameter context: the context
     
     - throws validation errors
     
     - returns: true on success
     */
    func validate<T: Any>( _ value: T?, context: [String: Any?]?) throws -> Bool
}

//
//  ValidatorProtocol.swift
//  validator
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

/**
 *  Validator protocol
 */
public protocol ValidatorProtocol {
    
    /// holds the occured errors
    var errors: [String] { get }
    
    /**
     required init
     (inspired by Eureka)
     
     - parameter initializer: the initializer callback
     
     - returns: the instance
     */
    init(@noescape _ initializer: Self -> ())
}

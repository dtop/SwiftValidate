//
//  ValidatorEmail.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorEmail: BaseValidator, ValidatorProtocol {
    
    required public init(@noescape _ initializer: ValidatorEmail -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    public override func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
       preconditionFailure("foo")
    }
}

//
//  ValidatorAlnum.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorAlnum: ValidatorCharset {
    
    /**
     Easy init
     
     - returns: the instance
     */
    required public init( _ initializer: (ValidatorCharset) -> () = { _ in }) {
        
        super.init(initializer)
        self.charset = CharacterSet.alphanumerics
    }
}

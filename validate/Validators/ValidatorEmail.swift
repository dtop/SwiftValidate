//
//  ValidatorEmail.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorEmail: BaseValidator, ValidatorProtocol {
    
    /// length of the local part
    private static let maxLengthLocalPart: Int = 64
    /// length of the hostname part
    private static let maxLengthHostnamePart: Int = 255
    
    /// nil is allowed
    public var allowNil: Bool = true
    
    /// Validates the local part of the mail addr (before @)
    public var validateLocalPart: Bool = true
    
    /// Validates the hostname part of the mail addr (after @)
    public var validateHostnamePart: Bool = true
    
    /// Validates if a tld is present
    public var validateToplevelDomain: Bool = true
    
    /// strict check
    public var strict: Bool = true
    
    /// generic invalid error message
    public var errorMessageInvalidAddress: String = NSLocalizedString("the entered address is invalid", comment: "ValidatorEmail - Invalid address")
    
    /// error message when local part is invalid
    public var errorMessageInvalidLocalPart: String = NSLocalizedString("the local part of the mail contains invalid characters", comment: "ValidatorEmail - invalid local part")

    /// error message when hostname part is invalid
    public var errorMessageInvalidHostnamePart: String = NSLocalizedString("the hostname part of the mail contains invalid characters", comment: "ValidatorEmail - invalid remote part")
    
    /// error message if the length was exceeded
    public var errorMessagePartLengthExceeded: String = NSLocalizedString("the %@ part is too long %i of max %i given", comment: "ValidatorEmail - Length exceeded")
    
    /**
     Easy init
     
     - returns: the instance
     */
    required public init( _ initializer: (ValidatorEmail) -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Validares the email address
     
     - parameter value:   the email address
     - parameter context: the context (unused)
     
     - throws: validation errors
     
     - returns: true if ok
     */
    public override func validate<T: Any>(_ value: T?, context: [String: Any?]?) throws -> Bool {
        
        // reset errors
        self.emptyErrors()
        
        if self.allowNil && nil == value {
            return true
        }
        
        if !self.validateHostnamePart && self.validateToplevelDomain {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Topleveldomain cannot be validated without the hostname"])
        }
        
        if let strVal = value as? String {
            
            if !self.validateMailFormat(address: strVal) {
                return false
            }
            
            guard let partial = self.splitEmailAddress(address: strVal) else {
                return false
            }
            
            let valid = ((self.doValidate(localPart: partial.local) || !self.validateLocalPart) && (self.doValidate(hostnamePart: partial.hostname) || !self.validateHostnamePart))
            
            return valid
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "no valid string value given"])
    }
    
    //MARK: - private functions -
    
    /**
    Validates the local part of the mail
    
    - parameter part: the local part (before @)
    
    - returns: true if ok
    */
    private func doValidate(localPart part: String) -> Bool {
        
        if !self.checkLength(value: part, maxLen: ValidatorEmail.maxLengthLocalPart, what: "local") {
            return false
        }
        
        var charset: CharacterSet = CharacterSet.alphanumerics
        charset.insert(charactersIn: "!#$%&'*+-/=?^_`{|}~")
        
        if let _ = part.rangeOfCharacter(from: charset.inverted) {
            
            return self.returnError(error: self.errorMessageInvalidLocalPart)
        }
        
        return true
    }
    
    /**
     Validates the hostname part of the mail
     
     - parameter part: the hostname part (after @)
     
     - returns: true of ok
     */
    private func doValidate(hostnamePart part: String) -> Bool {
        
        if !self.checkLength(value: part, maxLen: ValidatorEmail.maxLengthHostnamePart, what: "hostname") {
            return false
        }
        
        var result: Bool = false
        
        if self.validateToplevelDomain {
            do {
             
                let pattern = "\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])$"
                let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
                
                let x = regex.numberOfMatches(in: part, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: part.characters.count))
                result =  x > 0
            } catch _ {
                result = false
            }
        }
        
        let charset = CharacterSet.urlHostAllowed
        if let _ = part.rangeOfCharacter(from: charset.inverted) {
            
            return self.returnError(error: self.errorMessageInvalidHostnamePart)
        }
        
        return result
    }
    
    /**
    Validates obvious email issues
    
    - parameter address: the mail addr
    
    - returns: true if ok
    */
    private func validateMailFormat(address: String) -> Bool {
        
        
        if address.contains("..") {
            
            return self.returnError(error: self.errorMessageInvalidAddress)
        }
        
        if !address.contains("@") {
            
            return self.returnError(error: self.errorMessageInvalidAddress)
        }
        
        if address.components(separatedBy: "@").count > 2 {
            
            return self.returnError(error: self.errorMessageInvalidAddress)
        }
        
        return true
    }
    
    /**
     Splits the mail addr into local and hostname part
     
     - parameter address: the address
     
     - returns: the tupel
     */
    private func splitEmailAddress(address: String) -> (local: String, hostname: String)? {
        
        let parts = address.characters.split { $0 == "@" }.map(String.init)
        
        if parts.count != 2 {
            return nil
        }
        
        return (parts[0], parts[1])
    }
    
    /**
     Checks the length of a string
     
     - parameter value:  the part
     - parameter maxLen: the maximum length
     - parameter what:   what part (for error msg only)
     
     - returns: true if ok or nonstrict
     */
    private func checkLength(value: String, maxLen: Int, what: String) -> Bool {
        
        if self.strict && value.characters.count > maxLen {
            
            return self.returnError(error: String(format: self.errorMessagePartLengthExceeded, what, value.characters.count, maxLen))
        }
        
        return true
    }
}

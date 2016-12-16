# SwiftValidate
[![Build Status](https://travis-ci.org/dtop/SwiftValidate.svg)](https://travis-ci.org/dtop/SwiftValidate)
[![Compatibility](https://img.shields.io/badge/Swift-3.0-orange.svg)](https://developer.apple.com/swift)
[![DependencyManagement](https://img.shields.io/badge/CocoaPods-Compatible-brightgreen.svg)](https://cocoapods.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/dtop/SwiftValidate/master/LICENSE)
[![codebeat badge](https://codebeat.co/badges/e6b1e8da-2b4a-46b9-ad1d-9bdd057fbb58)](https://codebeat.co/projects/github-com-dtop-swiftvalidate)
[![codecov.io](https://codecov.io/github/dtop/SwiftValidate/coverage.svg?branch=master)](https://codecov.io/github/dtop/SwiftValidate?branch=master)
[![GitHub release](https://img.shields.io/github/release/dtop/SwiftValidate.svg)](https://github.com/dtop/SwiftValidate)
##### enhanced validation for swift

By [Danilo Topalovic](http://blog.danilo-topalovic.de).



* [Introduction]
* [Requirements]
* [Installation]
* [Usage]
* [Included Validators]
  + [Required]
  + [Empty]
  + [StrLen]
  + [Charset]
  + [Alnum]
  + [Email]
  + [Regex]
  + [Numeric]
  + [Between]
  + [GreaterThan]
  + [SmallerThan]
  + [DateTime]
  + [DateBetween]
  + [Callback]
  + [InArray]
* [Extensibility]


### Introduction

Unfortunately I did not find a fancy name for this software so I've called it what it is - a validator.

Heavily inspired by [Zend\Validate] and [Eureka] I started working on this component and I still add tests / validators.
if you encounter any issues or bugs please feel free to report the bug or even write a test for this bug in order to be good again when the bug is solved.

See also the [ExampleProject]

If you are also missing a kind of filtering for form inputs see [SwiftFilter]

## Requirements

* iOS 8.0+
* Xcode 7.0+

## Installation

See [CocoaPods] for easy installation into your project

Add `SwiftValidate` to your `Podfile` like


```

pod 'SwiftValidate', '~> 2.0.1'

```

and then run `pod install` in your directory as usual.

Of course you can use it in [Carthage] as well

```
github "dtop/SwiftValidate"

```

## Usage

All validators are usable completely on their own but one of the main advantages of `SwiftValidate` is that the validators are chainable.
Add as many validators to a single chain as you need for properly validate your value.

Add
```import SwiftValidate```
to your View Controller.

And then, you're all setup to start using it:

```swift
let validatorChain = ValidatorChain() {
    $0.stopOnFirstError = true
    $0.stopOnException = true
} <~~ ValidatorRequired() {
    $0.errorMessage = "Enter the value!"
} <~~ ValidatorEmpty() {
    $0.allowNil = false
} <~~ ValidatorStrLen() {
    $0.minLength = 3
    $0.maxLength = 30
    $0.errorMessageTooSmall = "My fancy own error message"
}

let myValue = "testValue"

let result = validatorChain.validate(myValue, context: nil)
let errors = validatorChain.errors
```

If you are dealing with a lot of values (e.g. a form result) you can easily predefine an ValidationIterator and add several chains linked to the form fields name to it.

see the extraction of the ValidationIteratorTests:

```swift

        // form values given by some user
        let formResults: [String: Any?] = [
            "name": "John Appleseed",
            "street": "1456 Sesame Street",
            "zipcode": "01526",
            "city": "Somewhere",
            "country": nil
        ]
        
        let validationIterator = ValidationIterator() {
            $0.resultForUnknownKeys = true
        }
        
        // name, street, city
        validationIterator.register(
            chain: ValidatorChain() {
                    $0.stopOnException = true
                    $0.stopOnFirstError = true
                }
                <~~ ValidatorRequired()
                <~~ ValidatorEmpty()
                <~~ ValidatorStrLen() {
                    $0.minLength = 3
                    $0.maxLength = 50
                },
            forKeys: ["name", "street"]
        )
        
        // zipcode
        validationIterator.register(
            chain: ValidatorChain() {
                $0.stopOnException = true
                $0.stopOnFirstError = true
            }
            <~~ ValidatorRequired()
            <~~ ValidatorStrLen() {
                $0.minLength = 5
                $0.maxLength = 5
            }
            <~~ ValidatorNumeric() {
                $0.allowString = true
                $0.allowFloatingPoint = false
            },
            forKey: "zipcode"
        )
        
        // country (not required but if present between 3 and 50 chars)
        validationIterator.register(
            chain: ValidatorChain() {
                $0.stopOnException = true
                $0.stopOnFirstError = true
            }
            <~~ ValidatorStrLen() {
                $0.minLength = 3
                $0.maxLength = 50
            },
            forKey: "country"
        )
        
        
        let validationResult = validationIterator.validate(formResults)
        let cityInError = validationIterator.isInError("city")

```


see [WiKi] for more examples and explinations

## Included Validators

#### ValidatorRequired()

Since all other validators allow nil from default setting, this validator can be added first to
check the value is present.
It is also equipped with a callback where you can decide by value and context if the requiry is satisfied or not.

Configuration

**Configuration**

| value                  |  type     | default | description                       |
|------------------------|:---------:|---------|-----------------------------------|
| `requirementCondition` |  closure  | ?       | optional custom requirement check |

**Error Messages**

+ `errorMessage` - error message if value is nil

---
#### ValidatorEmpty()

Tests if the given value is not an empty string

**Configuration**

| value          |  type  | default | description                     |
|----------------|:------:|---------|---------------------------------|
| `allowNil`     |  Bool  | true    | value can be nil                |

**Error Messages**

+ `errorMessage` - error message if value is empty

---
#### ValidatorStrLen()

Tests if a given value is between min and max in strlen

**Configuration**

| value          | type | default | description                |
|----------------|:----:|---------|----------------------------|
| `allowNil`     | Bool | true    | value an be nil            |
| `minLength`    |  Int | 3       | minimum length of string   |
| `maxLength`    |  Int | 30      | maximum length of string   |
| `minInclusive` | Bool | true    | minimum inclusive in value |
| `maxInclusive` | Bool | true    | maximum inclusive in value |

**Error Messages**

+ `errorMessageTooSmall: String` - error message if string is not long enaugh
+ `errorMessageTooLarge: String`- error message if string is too long

---
#### ValidatorCharset()

Validates that the given value contains only chars from the given character set

**configuration**

| value        | type           | default | description        |
|--------------|:--------------:|---------|--------------------|
| `allowNil`   | Bool           | true    | value an be nil    |
| `allowEmpty` | Bool           | false   | value can be empty |
| `charset`    | NSCharacterSet | !       | charset to compare |

**Error Messages**

+ `errorMessageStringDoesNotFit: String` - (optional)

---
### ValidatorAlnum()

Validates if the given value consists of alpha numerical chars only

```
This is a specialization of ValidatorCharset()
```

---
#### ValidatorEmail()

Validates a given email address

**Configuration**

| value                    | type | default | description                                             |
|--------------------------|:----:|---------|---------------------------------------------------------|
| `allowNil`               | Bool | true    | value an be nil                                         |
| `validateLocalPart`      | Bool | true    | the local part of the mail address will be validated    |
| `validateHostnamePart`   | Bool | true    | the hostname part of the mail address will be validated |
| `validateTopLevelDomain` | Bool | true    | the address has to have a topleveldomain                |
| `strict`                 | Bool | true    | the length of the parts will also be validated          |

**Error Messages**

+ `errorMessageInvalidAddress` - address is invalid
+ `errorMessageInvalidLocalPart` - the local part (before @) is invalid
+ `errorMessageInvalidHostnamePart` - the hostname is invalid
+ `errorMessagePartLengthExceeded` - a part is exceeding its length

---
#### ValidatorRegex()

Validates a given string against a user definded regex

| value             |            type            | default | description                        |
|-------------------|:--------------------------:|---------|------------------------------------|
| `allowNil`        |            Bool            | true    | nil is allowed                     |
| `pattern`         |           String           | -       | the pattern to match against       |
| `options`         | NSRegularExpressionOptions | 0       | options for the regular expression |
| `matchingOptions` |      NSMatchingOptions     | 0       | options for the matching           |

**Error Messages**

+ `errorMessageValueIsNotMatching` - value does not match teh given pattern

---
#### ValidatorNumeric()

Validates if the given value is a valid number

**Configuration**

| value                |        type       | default | description                        |
|----------------------|:-----------------:|---------|------------------------------------|
| `allowNil`           |        Bool       | true    | nil is allowed                     |
| `allowString`        |        Bool       | true    | value can be a numerical string    |
| `allowFloatingPoint` |        Bool       | true    | value can be a floatingpoint value |

**Error Messages**

+ `errorMessageNotNumeric` - value is not numeric

---
#### ValidatorBetween()

Validates if a numerical value is between 2 predefined values

Generic:

```swift
let validator = ValidatorBetween<Double>() {
    $0.minValue = 1.0
    $0.maxValue = 99.1
}
```

**Configuration**

| value          | type | default | description                               |
|----------------|:----:|---------|-------------------------------------------|
| `allowNil`     | Bool | true    | nil is allowed                            |
| `allowString`  | Bool | true    | value can be a numerical string           |
| `minValue`     | TYPE | 0       | the minimum value                         |
| `maxValue`     | TYPE | 0       | the maximum value                         |
| `minInclusive` | Bool | true    | minimum value inclusive (>= instead of >) |
| `maxInclusive` | Bool | true    | maximum value inclusive                   |

**Error Messages**

+ `errorMessageInvalidType` - invalid type given [-should be thrown-]
+ `errorMessageNotBetween` - value is not between the predefined values

---
#### ValidatorGreaterThan()

Validates if the given value is greater than the predefined one

Generic:

```swift
let validator = ValidatorGreaterThan<Double>() {
    $0.min = 1.0
}
```

**Configuration**

| value          | type | default | description                               |
|----------------|:----:|---------|-------------------------------------------|
| `allowNil`     | Bool | true    | nil is allowed                            |
| `min`          | TYPE | 0       | the value that needs to be exceeded       |
| `inclusive`    | Bool | true    | value itself inclusive                    |

**Error Messages**

+ `errorMessageInvalidType` - invalid type given [-should be thrown-]
+ `errorMessageNotGreaterThan` - value is not great enaugh

---
#### ValidatorSmallerThan()

Validates if the given value is smaller than the predefined one

Generic:

```swift
let validator = ValidatorSmallerThan<Double>() {
    $0.max = 10.0
}
```

**Configuration**

| value          | type | default | description                               |
|----------------|:----:|---------|-------------------------------------------|
| `allowNil`     | Bool | true    | nil is allowed                            |
| `max`          | TYPE | 0       | the value that needs to be exceeded       |
| `inclusive`    | Bool | true    | value itself inclusive                    |

**Error Messages**

+ `errorMessageInvalidType` - invalid type given [-should be thrown-]
+ `errorMessageNotSmallerThan` - value is not small enaugh

---
#### ValidatorDateTime()

Validates if the given date is a valid one

**Configuration**

| value          | type   | default | description                               |
|----------------|:------:|---------|-------------------------------------------|
| `allowNil`     | Bool   | true    | nil is allowed                            |
| `dateFormat`   | String | 0       | the date format to be parsed              |

**Error Messages**

+ `errorMessageInvalidDate` - invalid date given

---
#### ValidatorDateBetween()

Validates if the given date (NSDate or String) is between the predefined dates

**Configuration**

| value           |       type      | default | description                                                 |
|-----------------|:---------------:|---------|-------------------------------------------------------------|
| `allowNil`      |       Bool      | true    | nil is allowed                                              |
| `min`           |      NSDate     | !       | minimum date                                                |
| `max`           |      NSDate     | !       | maximum date                                                |
| `minInclusive`  | Bool            | true    | minimum value inclusive (>= instead of >)                   |
| `maxInclusive`  | Bool            | true    | maximum value inclusive                                     |
| `dateFormatter` | NSDateFormatter | !       | date formatter for parsing the string if string is expected |

**Error Messages**

+ `errorMessageNotBetween` - Date is not between the predefined ones

---
#### ValidatorCallback()

Executes the given callback and works with the results

**Configuration**

| value          | type     | default | description                               |
|----------------|:--------:|---------|-------------------------------------------|
| `allowNil`     | Bool     | true    | nil is allowed                            |
| `callback`     | closure  | !       | the callback to validate with             |

Callback be like:

```swift
let validator = ValidatorCallback() {
    $0.callback = {(validator: ValidatorCallback, value: Any?, context: [String : Any?]?) in
        
        if nil == value {
            /// you can throw
            throw NSError(domain: "my domain", code: 1, userInfo: [NSLocalizedDescriptionKey: "nil!!"])
        }
        
        return (false, "My Error Message")
        /// return (true, nil)
    }
}
```

---
#### ValidatorInArray()

Validates that the given value is contained in the predefined array

Generic:

```swift
let validator = ValidatorInArray<String>() {
    $0.array = ["Andrew", "Bob", "Cole", "Dan", "Edwin"]
}

let validator = ValidatorInArray<Double>() {
    $0.allowNil = false
    $0.array = [2.4, 3.1, 9.8, 4.9, 2.0]
}
```

**Configuration**

| value          | type     | default | description                               |
|----------------|:--------:|---------|-------------------------------------------|
| `allowNil`     | Bool     | true    | nil is allowed                            |
| `array`        | [TYPE]   | []      | the array with predefined values          |

**Error Messages**

+ `errorMessageItemIsNotContained` - given value is not contained in the array


# Extensibility

Non generic:

```swift
class MyValidator: BaseValidator, ValidatorProtocol {

    required public init( _ initializer: @noescape(MyValidator) -> () = { _ in }) {
        super.init()
        initializer(self)
    }
    
    override func validate<T: Any>( _ value: T?, context: [String: Any?]?) throws -> Bool {
        /// ...
    }
}
```

Generic:

```swift
class MyGenericValidator<TYPE where TYPE: Equatable>: ValidatorProtocol, ValidationAwareProtocol {

    required public init( _ initializer: @noescape(MyGenericValidator) -> () = { _ in }) {
        initializer(self)
    }

    public func validate<T: Any>( _ value: T?, context: [String: Any?]?) throws -> Bool {
        /// ...
    }
}
```

<!--- References -->

[Eureka]: https://github.com/xmartlabs/Eureka
[Zend\Validate]: https://github.com/zendframework/zend-validator
[CocoaPods]: https://cocoapods.org
[Carthage]: https://github.com/Carthage/Carthage
[WiKi]: https://github.com/dtop/SwiftValidate/wiki
[ExampleProject]: https://github.com/dtop/swift-validate-example
[SwiftFilter]: https://github.com/dtop/SwiftFilter

[Introduction]: #introduction
[Requirements]: #requirements
[Installation]: #installation
[Usage]: #usage
[Included Validators]: #included-validators
[Required]: #validatorrequired
[Empty]: #validatorempty
[StrLen]: #validatorstrlen
[Charset]: #validatorcharset
[Alnum]: #validatoralnum
[Email]: #validatoremail
[Regex]: #validatorregex
[Numeric]: #validatornumeric
[Between]: #validatorbetween
[GreaterThan]: #validatorgreaterthan
[SmallerThan]: #validatorsmallerthan
[DateTime]: #validatordatetime
[DateBetween]: #validatordatebetween
[Callback]: #validatorcallback
[InArray]: #validatorinarray
[Extensibility]: #extensibility






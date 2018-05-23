//
//  SignUpPresenter.swift
//  YURT
//
//  Created by Standret on 18.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class Validate {
    class func validate(object: String?, isReuired: Bool, field: String, pattern: String? = nil, min: Int = 0, max: Int = Int.max) -> (ValidationResult, String) {
        do {
            if (object ?? "").trimmingCharacters(in: .whitespaces).isEmpty {
                if isReuired {
                    return (.empty, "\(field) is required")
                }
                else {
                    return (.ok, "")
                }
            }
            let nsObject = object! as NSString
            if nsObject.length < min {
                return (.toShort, "\(field) must be not less than \(min) characters long.")
            }
            if nsObject.length > max {
                return (.toLong, "\(field) must be not more than \(max) characters long.")
            }
            if let _pattern = pattern {
                let regex = try NSRegularExpression(pattern: _pattern)
                if regex.matches(in: object!, range: NSRange(location: 0, length: nsObject.length)).count == 0 {
                    return (.inCorrect, "\(field) is incorrect.")
                }
            }
            return (.ok, "")
        }
        catch {
            print ("error \(error) in validate \(object!)")
            return (.inCorrect, "\(field) is incorrect.")
        }
    }
    
    
}

enum ValidationResult {
    case ok, inCorrect, taken
    case toShort, toLong, empty
}

enum ValidateField {
    case firstName(String?)
    case lastName(String?)
    case location(String?)
    case phone(String?)
    case email(String?)
    case password(String?)
    
    func validate() -> (ValidationResult, String) {
        switch self {
        case .email(let email):
            return Validate.validate(object: email, isReuired: true,  field: "Email", pattern: Constants.emailPattern)
        case .firstName(let fullName):
            return Validate.validate(object: fullName, isReuired: true,  field: "First Name", pattern: Constants.firstNamePattern, min: Constants.minFirstName, max: Constants.maxFirstName)
        case .lastName(let lastName):
            return Validate.validate(object: lastName, isReuired: true, field: "Last Name", pattern: Constants.lastNamePattern, min: Constants.minLastName, max: Constants.maxLastName)
        case .location(let location):
            return Validate.validate(object: location, isReuired: false,  field: "Location", min: Constants.minLocation, max: Constants.maxLocation)
        case .password(let password):
            return Validate.validate(object: password, isReuired: true,  field: "Password", pattern: Constants.passwordPattern, min: Constants.minPassword, max: Constants.maxPassword)
        case .phone(let phone):
            return Validate.validate(object: phone, isReuired: false, field: "Phone", pattern: Constants.phoneNumber)
        }
    }
}

protocol SignUpDelegate: Viewable {
    func reloadError(field: ValidateField)
    func donwloadImageComplete(isSuccess: Bool)
}

class SignUpPresenter: SttPresenter<SignUpDelegate> {
    
    var _accountService: IAccountService!
    
    var photoData: ResultUploadImageApiModel?
    var signUp: SttComand!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        signUp = SttComand(handler: onSignUp)
    }
    
    var firstName: String? {
        didSet {
            firstNameError = ValidateField.firstName(firstName).validate()
            delegate.reloadError(field: .firstName(firstName))
        }
    }
    var lastName: String? {
        didSet {
            lastNameError = ValidateField.lastName(lastName).validate()
            delegate.reloadError(field: .lastName(lastName))
        }
    }
    var location: String? {
        didSet {
            locationError = ValidateField.location(location).validate()
            delegate.reloadError(field: .location(location))
        }
    }
    var phone: String? {
        didSet {
            phoneError = ValidateField.phone(phone).validate()
            delegate.reloadError(field: .phone(phone))
        }
    }
    var email: String? {
        didSet {
            emailError = ValidateField.email(email).validate()
            delegate.reloadError(field: .email(email))
            
            if emailError.0 == .ok {
                _ = _accountService.existsEmail(email: email!)
                    .subscribe(onNext: { (result) in
                        if result {
                            self.emailError = (.taken, "Email is taken")
                            self.delegate.reloadError(field: .email(self.email!))
                        }
                    })
            }
        }
    }
    var password: String? {
        didSet {
            passwordError = ValidateField.password(password).validate()
            delegate.reloadError(field: .password(password))
        }
    }
    
    var firstNameError = (ValidationResult.ok, "")
    var lastNameError = (ValidationResult.ok, "")
    var locationError = (ValidationResult.ok, "")
    var phoneError = (ValidationResult.ok, "")
    var emailError = (ValidationResult.ok, "")
    var passwordError = (ValidationResult.ok, "")
    
    func onSignUp() {
         _ = signUp.useWork(observable: _accountService.signUp(firstName: firstName!, lastName: lastName!, location: location, phone: phone, email: email!, password: password!, image: photoData))
            .subscribe(onNext: { (res) in
                self.delegate.sendMessage(title: "Success", message: "Some description about successfully signUp. In production I delete this message")
            })
    }
    
    func uploadImage(image: UIImage) {
        _ = _accountService.uploadUserAvatar(image: image).subscribe(onNext: { (result) in
                self.photoData = result
                self.delegate.donwloadImageComplete(isSuccess: true)
            }, onError: { error in
                self.delegate.donwloadImageComplete(isSuccess: false)
            })
    }
}

//
//  SignUpPresenter.swift
//  YURT
//
//  Created by Standret on 18.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class Validate {
    class func validate(object: String?, field: String, isReuired: Bool = true, pattern: String? = nil, min: Int = 0, max: Int = Int.max, customIncorrectError: String? = nil) -> (ValidationResult, String) {
        do {
            if (object ?? "").trimmingCharacters(in: .whitespaces).isEmpty {
                if isReuired {
                    return (.empty, "\(field) is required.")
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
                if regex.matches(in: object!, range: NSRange(location: 0, length: nsObject.length)).count != 1 {
                    if let customError = customIncorrectError {
                        return (.inCorrect, customError)
                    }
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
    case isNotMatch
}

enum ValidateField {
    case firstName
    case lastName
    case location
    case phone
    case email
    case password
    case confirmPassword
    
    case roleAndOrganization
    case linkedin
    case education
    case skype
    
    func validate(rawObject: String?) -> (ValidationResult, String) {
    
        switch self {
        case .email:
            return Validate.validate(object: rawObject, field: "Email", pattern: Constants.emailPattern)
        case .firstName:
            return Validate.validate(object: rawObject, field: "First Name", pattern: Constants.firstNamePattern, min: Constants.minFirstName, max: Constants.maxFirstName)
        case .lastName:
            return Validate.validate(object: rawObject, field: "Last Name", pattern: Constants.lastNamePattern, min: Constants.minLastName, max: Constants.maxLastName)
        case .location:
            return Validate.validate(object: rawObject, field: "Location", min: Constants.minLocation, max: Constants.maxLocation)
        case .password:
            return Validate.validate(object: rawObject, field: "Password", pattern: Constants.passwordPattern, min: Constants.minPassword, max: Constants.maxPassword, customIncorrectError: Constants.passwordRequiered)
        case .confirmPassword:
            return Validate.validate(object: rawObject, field: "Confirm Password", pattern: Constants.passwordPattern, min: Constants.minPassword, max: Constants.maxPassword, customIncorrectError: Constants.passwordRequiered)
        case .phone:
            return Validate.validate(object: rawObject, field: "Phone", pattern: Constants.phoneNumber, min: Constants.minPhone, max: Constants.maxPhone)
        case .roleAndOrganization:
            return Validate.validate(object: rawObject, field: "Role and Organization", isReuired: false, min: 3, max: 300)
        case .linkedin:
            return Validate.validate(object: rawObject, field: "LinkedIn", isReuired: false, pattern: Constants.linkedInUrlPattern, min: 3, max: 300)
        case .education:
            return Validate.validate(object: rawObject, field: "Education", isReuired: false, min: 3, max: 300)
        case .skype:
            return Validate.validate(object: rawObject, field: "Skype", isReuired: false, pattern: Constants.skypePattern, min: Constants.minSkype, max: Constants.maxSkype)
        }
    }
}

protocol SignUpDelegate: SttViewContolable {
    func reloadError(field: ValidateField)
    func donwloadImageComplete(isSuccess: Bool)
    func changeProgress(label: String)
}

class SignUpPresenter: SttPresenter<SignUpDelegate> {
    
    var _accountService: AccountServiceType!
    
    var photoData: ResultUploadImageApiModel?
    var signUp: SttComand!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        signUp = SttComand(delegate: self, handler: { $0.onSignUp() }, handlerCanExecute: { $0.onCanExecuteSignUp() })
    }
    
    deinit {
        print ("Stt presenter deinit")
    }

    
    var firstName: String? {
        didSet {
            firstNameError = ValidateField.firstName.validate(rawObject: firstName)
            delegate!.reloadError(field: .firstName)
        }
    }
    var lastName: String? {
        didSet {
            lastNameError = ValidateField.lastName.validate(rawObject: lastName)
            delegate!.reloadError(field: .lastName)
        }
    }
    var location: String? {
        didSet {
            locationError = ValidateField.location.validate(rawObject: location)
            delegate!.reloadError(field: .location)
        }
    }
    var phone: String? {
        didSet {
            phoneError = ValidateField.phone.validate(rawObject: phone)
            delegate!.reloadError(field: .phone)
        }
    }
    
    var disposable: Disposable?
    var email: String? {
        didSet {
            emailError = ValidateField.email.validate(rawObject: email)
            self.delegate!.reloadError(field: .email)
            if emailError.0 == .ok {
                disposable?.dispose()
                disposable = _accountService.existsEmail(email: email!)
                    .subscribe(onNext: { (result) in
                        if result {
                            self.emailError = (.taken, "This email address is already registered.")
                        }
                        else {
                            self.emailError = self.emailError.0 != .ok ? self.emailError : (.ok, "")
                        }
                        self.delegate!.reloadError(field: .email)
                    }, onError: { err in
                        self.delegate!.reloadError(field: .email)
                    })
            }
            else {
                self.delegate!.reloadError(field: .email)
            }
        }
    }
    var password: String? {
        didSet {
            passwordError = ValidateField.password.validate(rawObject: password)
            delegate!.reloadError(field: .password)
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
                if res {
                    self.disposable?.dispose()
                    self.delegate?.navigate(to: "touchId", withParametr: WelcomNavigateModel(firstName: self.firstName!,
                                                                                             location: self.location!,
                                                                                             email: self.email!,
                                                                                             password: self.password!), callback: nil)
                }
            })
    }
    func onCanExecuteSignUp() -> Bool {
        return firstNameError.0 == .ok && lastNameError.0 == .ok && emailError.0 == .ok && locationError.0 == .ok && phoneError.0 == .ok && passwordError.0 == .ok
    }
    
    var previusDispose: Disposable?
    func uploadImage(image: UIImage) {
        previusDispose?.dispose()
        delegate!.changeProgress(label: PercentConverter().convert(value: 0))
        previusDispose = _accountService.uploadUserAvatar(image: image, progresHandler: { self.delegate!.changeProgress(label: PercentConverter().convert(value: $0)) }).subscribe(onNext: { (result) in
                self.photoData = result
                self.delegate!.donwloadImageComplete(isSuccess: true)
            }, onError: { error in
                self.delegate!.donwloadImageComplete(isSuccess: false)
            })
    }
}

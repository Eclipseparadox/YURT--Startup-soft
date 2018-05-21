//
//  SignUpViewController.swift
//  YURT
//
//  Created by Standret on 18.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: SttViewController<SignUpPresenter>, SignUpDelegate {
    
    @IBOutlet weak var vTakePhoto: UIView!
    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    @IBOutlet weak var inpFirstName: InputBox!
    @IBOutlet weak var inpLastName: InputBox!
    @IBOutlet weak var inpLocation: InputBox!
    @IBOutlet weak var inpPhone: InputBox!
    @IBOutlet weak var inpEmail: InputBox!
    @IBOutlet weak var inpPassword: InputBox!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBAction func clickLogIn(_ sender: Any) {
        self.close()
    }
    @IBAction func SignUpClick(_ sender: Any) {
        
    }
    
    let handlerFirstName = SttHandlerTextField()
    let handlerLastName = SttHandlerTextField()
    let handlerLocation = SttHandlerTextField()
    let handlerPhone = SttHandlerTextField()
    let handlerEmail = SttHandlerTextField()
    let handlerPassword = SttHandlerTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cnstrHeight.constant = heightScreen
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        vTakePhoto.createCircle()
        
        handlerFirstName.addTargetReturnKey(type: .didEndEditing, handler: { self.presenter.firstName = $0.text })
        handlerLastName.addTargetReturnKey(type: .didEndEditing, handler: { self.presenter.lastName = $0.text })
        handlerLocation.addTargetReturnKey(type: .didEndEditing, handler: { self.presenter.location = $0.text })
        handlerPhone.addTargetReturnKey(type: .didEndEditing, handler: { self.presenter.phone = $0.text })
        handlerEmail.addTargetReturnKey(type: .didEndEditing, handler: { self.presenter.email = $0.text })
        handlerPassword.addTargetReturnKey(type: .didEndEditing, handler: { self.presenter.password = $0.text })
        
        inpFirstName.textField.delegate = handlerFirstName
        inpLastName.textField.delegate = handlerLastName
        inpLocation.textField.delegate = handlerLocation
        inpPhone.textField.delegate = handlerPhone
        inpEmail.textField.delegate = handlerEmail
        inpPassword.textField.delegate = handlerPassword
        
        inpEmail.textField.keyboardType = .emailAddress
        inpPassword.textField.isSecureTextEntry = true
    }
    
    func reloadError(field: ValidateField) {
        switch field {
        case .email(_):
            inpEmail.errorText = presenter.emailError.1
        case .firstName(_):
            inpFirstName.errorText = presenter.firstNameError.1
        case .lastName(_):
            inpLastName.errorText = presenter.lastNameError.1
        case .location(_):
            inpLocation.errorText = presenter.locationError.1
        case .phone(_):
            inpPhone.errorText = presenter.phoneError.1
        case .password(_):
            inpPassword.errorText = presenter.passwordError.1
        }
    }
}

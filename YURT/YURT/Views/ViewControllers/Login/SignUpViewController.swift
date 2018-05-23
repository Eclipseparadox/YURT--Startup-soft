//
//  SignUpViewController.swift
//  YURT
//
//  Created by Standret on 18.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit
import RxAlamofire
import Alamofire
import RxSwift

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
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var maskOnPhoto: UIView!
    
    @IBAction func clickLogIn(_ sender: Any) {
        self.close()
    }
    @IBAction func SignUpClick(_ sender: Any) {
        presenter.firstName = inpFirstName.textField.text
        presenter.lastName = inpLastName.textField.text
        presenter.email = inpEmail.textField.text
        presenter.location = inpLastName.textField.text
        presenter.phone = inpPhone.textField.text
        presenter.password = inpPassword.textField.text
        
        if presenter.firstNameError.0 == .ok && presenter.lastNameError.0 == .ok && presenter.emailError.0 == .ok && presenter.locationError.0 == .ok && presenter.phoneError.0 == .ok && presenter.passwordError.0 == .ok {
            presenter.signUp.execute()
        }
    }
    
    let handlerFirstName = SttHandlerTextField()
    let handlerLastName = SttHandlerTextField()
    let handlerLocation = SttHandlerTextField()
    let handlerPhone = SttHandlerTextField()
    let handlerEmail = SttHandlerTextField()
    let handlerPassword = SttHandlerTextField()
    var cameraPicker: Camera!
    var indicatorImage: UIActivityIndicatorView!
    var indicatorSignUp: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraPicker = Camera(parent: self, handler: { (image) in
            
            self.imgUser.isHidden = false
            self.imgUser.image = image
            self.maskOnPhoto.isHidden = false
            self.indicatorImage.startAnimating()
            self.btnSignUp.isEnabled = false
            self.presenter.uploadImage(image: image)
        })
        
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
        
        vTakePhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnPhoto(_:))))
        imgUser.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnPhoto(_:))))
        
        indicatorImage = maskOnPhoto.setIndicator()
        indicatorImage.color = UIColor.white
        
        indicatorSignUp = btnSignUp.setIndicator()
        indicatorSignUp.color = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.signUp.useIndicator(button: btnSignUp)
    }
    
    @objc func clickOnPhoto(_ send: Any) {
        cameraPicker.showPopuForDecision()
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
    
    func donwloadImageComplete(isSuccess: Bool) {
        indicatorImage.stopAnimating()
        self.btnSignUp.isEnabled = true
        if isSuccess {
            maskOnPhoto.isHidden = true
        }
        else {
            self.createAlerDialog(title: "Error", message: "Could not upload photo")
        }
    }
}


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
    func changeProgress(label: String) {
        lblPercent.text = label
    }
    
    
    @IBOutlet weak var lblPercent: UILabel!
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
    
    var isAdd = false
    @IBAction func SignUpClick(_ sender: Any) {
        
        presenter.firstName = inpFirstName.textField.text
        presenter.lastName = inpLastName.textField.text
        presenter.email = inpEmail.textField.text
        presenter.location = inpLocation.textField.text
        presenter.phone = inpPhone.textField.text
        presenter.password = inpPassword.textField.text
        
        if !isAdd {
            isAdd = true
            
            inpFirstName.deleteErrorAfterStartEditing = false
            inpLastName.deleteErrorAfterStartEditing = false
            inpLocation.deleteErrorAfterStartEditing = false
            inpPhone.deleteErrorAfterStartEditing = false
            inpEmail.deleteErrorAfterStartEditing = false
            inpPassword.deleteErrorAfterStartEditing = false
            
            handlerFirstName.addTarget(type: .editing, delegate: self, handler: { $0.presenter.firstName = $1.text }, textField: inpFirstName.textField)
            handlerLastName.addTarget(type: .editing, delegate: self, handler: { $0.presenter.lastName = $1.text }, textField: inpLastName.textField)
            handlerLocation.addTarget(type: .editing, delegate: self, handler: { $0.presenter.location = $1.text }, textField: inpLocation.textField)
            handlerPhone.addTarget(type: .editing, delegate: self, handler: { $0.presenter.phone = $1.text }, textField: inpPhone.textField)
            handlerEmail.addTarget(type: .editing, delegate: self, handler: { $0.presenter.email = $1.text }, textField: inpEmail.textField)
            handlerPassword.addTarget(type: .editing, delegate: self, handler: { $0.presenter.password = $1.text }, textField: inpPassword.textField)
        }
        
        presenter.signUp.execute()
    }
    
    let handlerFirstName = SttHandlerTextField()
    let handlerLastName = SttHandlerTextField()
    let handlerLocation = SttHandlerTextField()
    let handlerPhone = SttHandlerTextField()
    let handlerEmail = SttHandlerTextField()
    let handlerPassword = SttHandlerTextField()
    var cameraPicker: SttCamera!
    var indicatorImage: UIActivityIndicatorView!
    var indicatorSignUp: UIActivityIndicatorView!
    
    deinit {
        print ("deinit sign up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style = .lightContent
        cameraPicker = SttCamera(parent: self, handler: { [weak self] (image) in

            self?.imgUser.isHidden = false
            self?.imgUser.image = image
            self?.maskOnPhoto.isHidden = false
            self?.indicatorImage.startAnimating()
            self?.btnSignUp.isEnabled = false
            self?.presenter.uploadImage(image: image)
        })
        
        cnstrHeight.constant = heightScreen
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        vTakePhoto.createCircle()
        
        handlerFirstName.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.firstName = $1.text }, textField: inpFirstName.textField)
        handlerFirstName.addTarget(type: .shouldReturn, delegate: self, handler: { (view, _) in view.inpLastName.textField.becomeFirstResponder() }, textField: inpFirstName.textField)
        handlerLastName.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.lastName = $1.text }, textField: inpLastName.textField)
        handlerLastName.addTarget(type: .shouldReturn, delegate: self, handler: { (view, _) in view.inpLocation.textField.becomeFirstResponder() }, textField: inpLastName.textField)
        handlerLocation.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.location = $1.text }, textField: inpLocation.textField)
        handlerLocation.addTarget(type: .shouldReturn, delegate: self, handler: { (view, _) in view.inpPhone.textField.becomeFirstResponder() }, textField: inpLocation.textField)
        handlerPhone.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.phone = $1.text }, textField: inpPassword.textField)
        handlerPhone.addTarget(type: .shouldReturn, delegate: self, handler: { (view, _) in view.inpEmail.textField.becomeFirstResponder() }, textField: inpPassword.textField)
        handlerEmail.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.email = $1.text }, textField: inpEmail.textField)
        handlerEmail.addTarget(type: .shouldReturn, delegate: self, handler: { (view, _) in view.inpPassword.textField.becomeFirstResponder() }, textField: inpEmail.textField)
        handlerPassword.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.password = $1.text }, textField: inpPassword.textField)
        handlerPassword.addTarget(type: .shouldReturn, delegate: self, handler: { $0.SignUpClick($1) }, textField: inpPassword.textField)

        inpFirstName.textField.delegate = handlerFirstName
        inpLastName.textField.delegate = handlerLastName
        inpLocation.textField.delegate = handlerLocation
        inpPhone.textField.delegate = handlerPhone
        inpEmail.textField.delegate = handlerEmail
        inpPassword.textField.delegate = handlerPassword
        
        inpEmail.textField.keyboardType = .emailAddress
        inpPhone.textField.keyboardType = .numberPad
        inpPassword.textField.isSecureTextEntry = true
        
        //vTakePhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickOnPhoto(_:))))
        //imgUser.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickOnPhoto(_:))))
        
        indicatorImage = maskOnPhoto.setIndicator()
        indicatorImage.color = UIColor.white
        
        indicatorSignUp = btnSignUp.setIndicator()
        indicatorSignUp.color = UIColor.white
        
        inpPassword.hintText = Constants.passwordRequiered
    }
    
    private var firstStart = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstStart {
            presenter.signUp.useIndicator(button: btnSignUp)
            firstStart = false
        }
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
        default: break;
        }
    }
    
    func donwloadImageComplete(isSuccess: Bool) {
        lblPercent.text = "0%"
        indicatorImage.stopAnimating()
        self.btnSignUp.isEnabled = true
        maskOnPhoto.isHidden = true
        if !isSuccess {
            self.imgUser.isHidden = true
        }
    }
}

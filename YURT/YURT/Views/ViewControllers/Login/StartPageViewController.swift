//
//  StartPageViewController.swift
//  YURT
//
//  Created by Standret on 17.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
import AVFoundation
import LocalAuthentication
import KeychainSwift

class StartPageViewController: SttViewController<StartPagePresenter>, StartPageDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    @IBOutlet weak var inpEmail: InputBox!
    @IBOutlet weak var inpPassword: InputBox!
    @IBOutlet weak var vbtnLinkedin: UIView!
    @IBOutlet weak var vbtnTouchId: UIView!
    @IBOutlet weak var btnSignIn: UIButton!
    
    let kSafariViewControllerCloseNotification = "kSafariViewControllerCloseNotification"
    
    let handlerEmail = SttHandlerTextField()
    let handlerPassword = SttHandlerTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style = .lightContent
        cnstrHeight.constant = heightScreen - 64
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        handlerEmail.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.email = $1.text }, textField: inpEmail.textField)
        handlerPassword.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.password = $1.text }, textField: inpPassword.textField)
        
        inpEmail.textField.keyboardType = .emailAddress
        inpPassword.textField.isSecureTextEntry = true
        
        inpEmail.textField.text = "qq123@uuu.uuu"
        inpPassword.textField.text = "Qwerty1"

        presenter.email = inpEmail.textField.text
        presenter.password = inpPassword.textField.text
        
        vbtnLinkedin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLinkedinClick(_:))))
        vbtnTouchId.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTouchId(_:))))
        
        prepareTouchId()
    }
    
    private var firstStart = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstStart {
            presenter.signIn.useIndicator(button: btnSignIn)
            presenter.touchIdAuth.addHandler(start: {
                self.btnSignIn.setEnabled(isEnabled: false)
                self.vbtnTouchId.isUserInteractionEnabled = false
                self.vbtnLinkedin.isUserInteractionEnabled = false
                
                self.vbtnTouchId.viewWithTag(1)?.isHidden = true
                self.vbtnTouchId.viewWithTag(2)?.alpha = 0.8
                self.vbtnTouchId.viewWithTag(3)?.alpha = 0.8
                self.vbtnTouchId.viewWithTag(4)?.isHidden = false
                
            }) {
                self.btnSignIn.setEnabled(isEnabled: true)
                self.vbtnTouchId.isUserInteractionEnabled = true
                self.vbtnLinkedin.isUserInteractionEnabled = true
                
                self.vbtnTouchId.viewWithTag(1)?.isHidden = false
                self.vbtnTouchId.viewWithTag(2)?.alpha = 1
                self.vbtnTouchId.viewWithTag(3)?.alpha = 1
                self.vbtnTouchId.viewWithTag(4)?.isHidden = true
            }
            presenter.linkedinAuth.addHandler(start: {
                self.btnSignIn.setEnabled(isEnabled: false)
                self.vbtnTouchId.isUserInteractionEnabled = false
                self.vbtnLinkedin.isUserInteractionEnabled = false
                
                self.vbtnLinkedin.viewWithTag(1)?.isHidden = true
                self.vbtnLinkedin.viewWithTag(2)?.alpha = 0.8
                self.vbtnLinkedin.viewWithTag(3)?.alpha = 0.8
                self.vbtnLinkedin.viewWithTag(4)?.isHidden = false
            }, end: {
                self.btnSignIn.setEnabled(isEnabled: true)
                self.vbtnTouchId.isUserInteractionEnabled = true
                self.vbtnLinkedin.isUserInteractionEnabled = true
                
                self.vbtnLinkedin.viewWithTag(1)?.isHidden = false
                self.vbtnLinkedin.viewWithTag(2)?.alpha = 1
                self.vbtnLinkedin.viewWithTag(3)?.alpha = 1
                self.vbtnLinkedin.viewWithTag(4)?.isHidden = true
                })
            firstStart = false
        }
    }
    
    @IBAction func signInClick(_ sender: Any) {
        presenter.email = inpEmail.textField.text
        presenter.password = inpPassword.textField.text
        
        presenter.signIn.execute()
    }
    
    @objc func onLinkedinClick(_ sender: UITapGestureRecognizer) {
        let vc = SttOauthProvider.getLinkedinOauth(redirectUrl: Constants.apiUrl,
                                          clientId: Constants.cleintId,
                                          clientSecret: Constants.clientSecret) { (token) in
                                            self.presenter.linkedinAccesToken = token.access_token
                                            self.presenter.linkedinAuth.execute()
                                        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func prepareTouchId() {
        let email = KeychainSwift().get(Constants.idEmeail)
        let password = KeychainSwift().get(Constants.idPassword)
        
        if email != nil && password != nil {
            let authContext = LAContext()
            var error: NSError?
            
            if !authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                self.vbtnTouchId.alpha = 0.6
            }
        }
        else {
            self.vbtnTouchId.alpha = 0.6
        }
    }
    
    @objc func onTouchId(_ sender: Any) {
        let email = KeychainSwift().get(Constants.idEmeail)
        let password = KeychainSwift().get(Constants.idPassword)
        
        if email != nil && password != nil {
            let authContext = LAContext()
            let authReason = "Use Touch ID to sign in YURT application"
            
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: authReason) { (success, error) in
                if success {
                    DispatchQueue.main.async{
                        self.presenter.email = email
                        self.presenter.password = password
                        self.presenter.touchIdAuth.execute()
                    }
                }
            }
        }
    }

    func addError() {
        inpPassword.errorText = presenter.passwordError
        inpEmail.errorText = "  "
    }
}

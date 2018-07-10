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
import SafariServices

class StartPageViewController: SttViewController<StartPagePresenter>, StartPageDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    @IBOutlet weak var inpEmail: InputBox!
    @IBOutlet weak var inpPassword: InputBox!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnLinkedin: UIButton!
    
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
    }
    
    private var firstStart = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstStart {
            presenter.signIn.useIndicator(button: btnSignIn)
            presenter.linkedinAuth.useIndicator(button: btnLinkedin)
            presenter.linkedinAuth.addHandler(start: { self.btnSignIn.setEnabled(isEnabled: false) }, end: { self.btnSignIn.setEnabled(isEnabled: true) })
            firstStart = false
        }
    }
    
    @IBAction func signInClick(_ sender: Any) {
        presenter.email = inpEmail.textField.text
        presenter.password = inpPassword.textField.text
        
        presenter.signIn.execute()
    }
    
    @IBAction func onLinkedinClick(_ sender: Any) {
        let vc = SttOauthProvider.getLinkedinOauth(redirectUrl: Constants.apiUrl,
                                          clientId: Constants.cleintId,
                                          clientSecret: Constants.clientSecret) { (token) in
                                            self.presenter.linkedinAccesToken = token.access_token
                                            self.presenter.linkedinAuth.execute()
                                        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addError() {
        inpPassword.errorText = presenter.passwordError
        inpEmail.errorText = "  "
    }
}

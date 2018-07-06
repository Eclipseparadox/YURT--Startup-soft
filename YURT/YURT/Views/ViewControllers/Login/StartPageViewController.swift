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

class StartPageViewController: SttViewController<StartPagePresenter>, StartPageDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    @IBOutlet weak var inpEmail: InputBox!
    @IBOutlet weak var inpPassword: InputBox!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(safariLogin(_:)), name: NSNotification.Name(rawValue: kSafariViewControllerCloseNotification), object: nil)
    }
    
    func safariLogin(notification: NSNotification) {
        // get the url from the auth callback
        let url = notification.object as! NSURL
        // Finally dismiss the Safari View Controller with:
        //self.safariVC!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private var firstStart = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstStart {
            presenter.signIn.useIndicator(button: btnSignIn)
            firstStart = false
        }
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print("redirect to: \(URL)")
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//        controller.dismissViewControllerAnimated(true) { () -> Void in
//            print("You just dismissed the login view.")
//        }
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("didLoadSuccessfully: \(didLoadSuccessfully)")
        
    }
    
    let speaker = AVSpeechSynthesizer()
    let dialogue = AVSpeechUtterance(string: "Hello world")
    
    @IBAction func signInClick(_ sender: Any) {
        presenter.email = inpEmail.textField.text
        presenter.password = inpPassword.textField.text
        
        presenter.signIn.execute()
    }
    
    @IBAction func onLinkedinClick(_ sender: Any) {
        let ecodedDomain =  Constants.apiUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        print(URL(string: "\(Constants.apiUrl)/api/v1/mobile/account/externallogin?provider=LinkedIn&response_type=token&client_id=self&redirect_uri=\(ecodedDomain)&state=HKZk-6OU85OSGfSmciskKvUHbawdaTz0A6TbvU2UWZc")!)
        let linkedinPage = SFSafariViewController(url: URL(string: "\(Constants.apiUrl)/api/v1/mobile/account/externallogin?provider=LinkedIn&response_type=token&client_id=self&redirect_uri=\(ecodedDomain)&state=HKZk-6OU85OSGfSmciskKvUHbawdaTz0A6TbvU2UWZc")!)
        linkedinPage.delegate = self
        present(linkedinPage, animated: true, completion: nil)
    }
    
    @objc func safariLogin(_ notification : Notification) {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CallbackNotification"), object: nil)
        
        guard let url = notification.object as? URL else {
            return
        }
        
        // Parse url ...
        
    }
    
    func addError() {
        inpPassword.errorText = presenter.passwordError
        inpEmail.errorText = "  "
    }
}

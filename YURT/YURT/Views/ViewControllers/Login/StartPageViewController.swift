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

class StartPageViewController: SttViewController<StartPagePresenter>, StartPageDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    @IBOutlet weak var inpEmail: InputBox!
    @IBOutlet weak var inpPassword: InputBox!
    @IBOutlet weak var btnSignIn: UIButton!
    
    let handlerEmail = SttHandlerTextField()
    let handlerPassword = SttHandlerTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style = .lightContent
        cnstrHeight.constant = heightScreen
        hideNavigationBar = true
        
        handlerEmail.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.email = $1.text }, textField: inpEmail.textField)
        handlerPassword.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.password = $1.text }, textField: inpPassword.textField)
        
        inpEmail.textField.keyboardType = .emailAddress
        inpPassword.textField.isSecureTextEntry = true
        
        inpEmail.textField.text = "sovec_pizdec@uu.uu"
        inpPassword.textField.text = "Qwerty1"
        
        presenter.email = inpEmail.textField.text
        presenter.password = inpPassword.textField.text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.signIn.useIndicator(button: btnSignIn)
    }
    
    let speaker = AVSpeechSynthesizer()
    let dialogue = AVSpeechUtterance(string: "Hello world")
    
    @IBAction func signInClick(_ sender: Any) {
        presenter.email = inpEmail.textField.text
        presenter.password = inpPassword.textField.text
        
        presenter.signIn.execute()
//        let content = UNMutableNotificationContent()
//
//        //adding title, subtitle, body and badge
//        content.title = "Hey this is Simplified iOS"
//        content.subtitle = "iOS Development is fun"
//        content.body = "We are learning about iOS Local Notification"
//        content.badge = 1
//
//        //getting the notification trigger
//        //it will be called after 5 seconds
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//        //getting the notification request
//        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
//
//        //adding the notification to notification center
//        UNUserNotificationCenter.current().add(request) { (error) in
//            print(error)
//        }
        
//        dialogue.rate = AVSpeechUtteranceDefaultSpeechRate;
//        dialogue.voice = AVSpeechSynthesisVoice(language: "en-gb")
//
//        guard speaker.isSpeaking else
//        {
//            speaker.speak(dialogue)
//            return
//        }
    }
    
    func addError() {
        inpPassword.errorText = presenter.passwordError
    }
}

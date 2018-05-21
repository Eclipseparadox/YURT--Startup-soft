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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cnstrHeight.constant = heightScreen
        hideNavigationBar = true
    }
    
    let speaker = AVSpeechSynthesizer()
    let dialogue = AVSpeechUtterance(string: "Hello world")
    
    @IBAction func signInClick(_ sender: Any) {
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
        
        dialogue.rate = AVSpeechUtteranceDefaultSpeechRate;
        dialogue.voice = AVSpeechSynthesisVoice(language: "en-gb")
        
        guard speaker.isSpeaking else
        {
            speaker.speak(dialogue)
            return
        }
        
        
    }
    
}

//
//  AppDelegate.swift
//  YURT
//
//  Created by Standret on 07.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import KeychainSwift
import SDWebImage
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import RealmSwift
import Realm

extension AppDelegate {
    func configureStartOption()  {
        KeychainSwift().synchronizable = false
        var storyboardName = "Login"
        if KeychainSwift().get(Constants.tokenKey) != nil {
            do {
                let realm = try Realm()
                if let auth = realm.objects(RealmAuth.self).last {
                    let minutes = auth.dateCreated.differenceInMinutes()
                    if minutes < 60 && minutes > -60 {
                        storyboardName = "Main"
                    }
                    else {
                        KeychainSwift().delete(Constants.tokenKey)
                        try! realm.write {
                            realm.deleteAll()
                        }
                    }
                }
            }
            catch {
                print (error)
            }
        }
        
        let stroyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewContrl = stroyboard.instantiateViewController(withIdentifier: "start")
        
        self.window?.rootViewController = viewContrl
        self.window?.makeKeyAndVisible()
    }
    
    func clearKeychainIfWillUnistall() {
        let freshInstall = !UserDefaults.standard.bool(forKey: "alreadyInstalled")
        if freshInstall {
            KeychainSwift().clear()
            UserDefaults.standard.set(true, forKey: "alreadyInstalled")
        }
    }
    
    func configureCacheOptions() {
        SDWebImageManager.shared().imageCache?.config.maxCacheAge = Constants.maxCacheAge
        SDWebImageManager.shared().imageCache?.config.maxCacheSize = UInt(Constants.maxImageCacheSize)
        
        let size = Double((SDWebImageManager.shared().imageCache?.getSize())!)
        print("image cache size: \(size / 1024.0 / 1024.0)mb\nused: \(size * 100.0 / Double(Constants.maxImageCacheSize))/100%")
    }
    
    func useAppCenter() {
        MSAppCenter.start("b6ce0bef-0492-4e11-bb57-438af40b5b06", withServices:[
            MSAnalytics.self,
            MSCrashes.self
        ])
    }
}

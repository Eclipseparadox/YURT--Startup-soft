//
//  AppDelegate.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var _accountService: IAccountService!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ServiceInjectorAssembly.instance().inject(into: self)
        self.useAppCenter()
        self.clearKeychainIfWillUnistall()
        self.configureStartOption()
        self.configureCacheOptions()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        SttGlobalObserver.applicationStatusChanged(status: .EnterBackgound)
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        SttGlobalObserver.applicationStatusChanged(status: .EnterForeground)
    }
}


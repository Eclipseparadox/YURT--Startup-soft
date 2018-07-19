//
//  AppDelegate.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import RxSwift

extension URL {
    
    public var queryParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return [:]
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}

class SttOpenUrlHandler {
    
    private static var registeredScheme = Set<String>()
    private static var publisher = PublishSubject<([String: String], String)>()
    static var openUrlObservable: Observable<([String: String], String)> { return publisher }
    
    class func openingUrl(url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            publisher.onNext((url.queryParameters, "\(url)"))
        }
    }
}

class AppDelegateEvent {
    private static var publisher = PublishSubject<String>()
    static var openUrlObservable: Observable<String> { return publisher }
    
    class func publish(key: String) {
        publisher.onNext(key)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var _accountService: AccountServiceType!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ServiceInjectorAssembly.instance().inject(into: self)
        self.useAppCenter()
        self.clearKeychainIfWillUnistall()
        self.configureStartOption()
        self.configureCacheOptions()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        SttOpenUrlHandler.openingUrl(url: url, options: options)
        SttLog.trace(message: "OpenUrl", key: "\(url)")
        return true
    }
    
    private var timer: Timer?
    func applicationDidEnterBackground(_ application: UIApplication) {
        timer?.invalidate()
        UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        timer = Timer(fireAt: Date().addingTimeInterval(3600), interval: 10, target: self, selector: #selector(onFireTimer(_:)), userInfo: nil, repeats: false)
        RunLoop.current.add(timer!, forMode: .commonModes)
        SttGlobalObserver.applicationStatusChanged(status: .EnterBackgound)
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        SttGlobalObserver.applicationStatusChanged(status: .EnterForeground)
    }
    
    @objc private func onFireTimer(_ sender: Any) {
        if _accountService.isSignIn {
            print("sign out")
            _accountService.signOut()
            AppDelegateEvent.publish(key: "signOut")
        }
    }
}


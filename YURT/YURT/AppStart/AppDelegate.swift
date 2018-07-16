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
        
    func applicationDidEnterBackground(_ application: UIApplication) {
        SttGlobalObserver.applicationStatusChanged(status: .EnterBackgound)
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        SttGlobalObserver.applicationStatusChanged(status: .EnterForeground)
    }
}


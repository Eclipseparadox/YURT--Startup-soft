//
//  AppDelegate.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import RxSwift

enum ApplicationStatus {
    case EnterBackgound
    case EnterForeground
}

class GlobalObserver {
    private static let publisher = PublishSubject<ApplicationStatus>()
    static var observableStatusApplication: Observable<ApplicationStatus> { return publisher }
    
    class func applicationStatusChanged(status: ApplicationStatus) {
        publisher.onNext(status)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.useAppCenter()
        self.configureStartOption()
        self.configureCacheOptions()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        GlobalObserver.applicationStatusChanged(status: .EnterBackgound)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        GlobalObserver.applicationStatusChanged(status: .EnterForeground)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


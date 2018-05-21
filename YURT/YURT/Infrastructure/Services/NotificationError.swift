//
//  NotificationError.swift
//  YURT
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

protocol INotificationError {
    var errorObservable: Observable<String> { get }
    
    func useError<T>(observable: Observable<T>) -> Observable<T>
}

class NotificationError: INotificationError {
    
    let subject = PublishSubject<String>()
    
    var errorObservable: Observable<String> { return subject }
    
    func useError<T>(observable: Observable<T>) -> Observable<T> {
        return observable.do(onError: { (error) in
            self.subject.onNext("\(error)")
        })
    }
}

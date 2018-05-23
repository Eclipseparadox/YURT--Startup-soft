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
    var errorObservable: Observable<BaseError> { get }
    
    func useError<T>(observable: Observable<T>) -> Observable<T>
}

class NotificationError: INotificationError {
    
    let subject = PublishSubject<BaseError>()
    
    var errorObservable: Observable<BaseError> { return subject }
    
    func useError<T>(observable: Observable<T>) -> Observable<T> {
        return observable.do(onError: { (error) in
            if let er = error as? BaseError {
                self.subject.onNext(er)
            }
            else {
                self.subject.onNext(BaseError.unkown("\(error)"))
            }
        })
    }
}

//
//  NotificationError.swift
//  YURT
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

protocol NotificationErrorType: class {
    var errorObservable: Observable<SttBaseError> { get }
    
    func useError<T>(observable: Observable<T>, ignoreBadRequest: Bool) -> Observable<T>
}

extension NotificationErrorType {
    func useError<T>(observable: Observable<T>, ignoreBadRequest: Bool = false) -> Observable<T> {
        return self.useError(observable: observable, ignoreBadRequest: ignoreBadRequest)
    }

}

class NotificationError: NotificationErrorType {
    
    let subject = PublishSubject<SttBaseError>()
    
    var errorObservable: Observable<SttBaseError> { return subject }
    
    func useError<T>(observable: Observable<T>, ignoreBadRequest: Bool) -> Observable<T> {
        return observable.do(onError: { (error) in
            if let er = error as? SttBaseError {
                var flag = true
                if ignoreBadRequest {
                    switch er {
                    case .apiError(let api):
                        switch api {
                        case .badRequest( _):
                            flag = false
                        default: break
                        }
                    default: break
                    }
                }
                if flag {
                    self.subject.onNext(er)
                }
            }
            else {
                self.subject.onNext(SttBaseError.unkown("\(error)"))
            }
        })
    }
}

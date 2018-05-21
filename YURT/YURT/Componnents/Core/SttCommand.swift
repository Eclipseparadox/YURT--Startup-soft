//
//  SttCommand.swift
//  YURT
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

class SttComand {
    
    private var handlerStart: (() -> Void)?
    private var handlerEnd: (() -> Void)?
    private var executeHandler: (() -> Void)
    
    var singleCallEndCallback = true
    private var isCall = false
    
    init (handler: @escaping () -> Void) {
        executeHandler = handler
        isCall = false
    }
    
    func addHandler(start: (() -> Void)?, end: (() -> Void)?) {
        handlerStart = start
        handlerEnd = end
    }
    
    func execute() {
        if let handler = handlerStart {
            handler()
        }
        executeHandler()
    }
}

extension SttComand {
    func useWork<T>(observable: Observable<T>) -> Observable<T> {
        return observable.do(onNext: { (element) in
            if self.handlerEnd != nil && self.singleCallEndCallback && !self.isCall {
                self.handlerEnd!()
                self.isCall = false
            }
        }, onError: { (error) in
            if self.handlerEnd != nil && !self.isCall {
                self.handlerEnd!()
                self.isCall = false
            }
        }, onCompleted: {
            if self.handlerEnd != nil && !self.isCall {
                self.handlerEnd!()
                self.isCall = false
            }
        })
    }
}

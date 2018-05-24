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
    private var canExecuteHandler: (() -> Bool)?
    
    var singleCallEndCallback = true
    private var isCall = false
    
    init (handler: @escaping () -> Void, handlerCanExecute: (() -> Bool)? = nil) {
        executeHandler = handler
        canExecuteHandler = handlerCanExecute
        isCall = false
    }
    
    func addHandler(start: (() -> Void)?, end: (() -> Void)?) {
        handlerStart = start
        handlerEnd = end
    }
    
    func execute() {
        if canExecute() {
            if let handler = handlerStart {
                handler()
            }
            executeHandler()
        }
        else {
            Log.trace(message: "Command could not be execute", key: "SttComand")
        }
    }
    func canExecute() -> Bool {
        if let handler = canExecuteHandler {
            return handler()
        }
        return true
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

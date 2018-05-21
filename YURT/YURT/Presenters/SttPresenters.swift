//
//  SttPresenters.swift
//  YURT
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class SttPresenter<TDelegate> : ViewInjector {
    
    var delegate: TDelegate!
    
    var _notificationError: INotificationError!
    
    required init() { }
    func injectView(delegate: Viewable) {
        ServiceInjectorAssembly.instance().inject(into: self)
        self.delegate = delegate as! TDelegate
        
        _ = _notificationError.errorObservable.subscribe(onNext: { (error) in
            if self.delegate is Viewable {
                (self.delegate as! Viewable).sendError(error: error)
            }
            else {
                print(error)
            }
        })
        presenterCreating()
    }
    
    func presenterCreating() { }
}

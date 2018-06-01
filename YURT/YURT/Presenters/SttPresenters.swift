//
//  SttPresenters.swift
//  YURT
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol SttPresenterType: class { }

class SttPresenter<TDelegate> : ViewInjector, SttPresenterType {
    
    private weak var _delegate: Viewable!
    var delegate: TDelegate { return _delegate as! TDelegate }
    
    weak var _notificationError: INotificationError!
    
    required init() { }
    func injectView(delegate: Viewable) {
        ServiceInjectorAssembly.instance().inject(into: self)
        self._delegate = delegate
        
        _ = _notificationError.errorObservable.subscribe(onNext: { (err) in
            self._delegate.sendError(error: err)
        })
        presenterCreating()
    }
    
    func presenterCreating() { }
    
    func prepare(parametr: Any?) { }
}

//
//  SttPresenters.swift
//  YURT
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class SttPresenter<TDelegate> : Defaultable {
    var delegate: TDelegate!
    
    required init(delegate: Viewable) {
        self.delegate = delegate as! TDelegate
        
        presenterCreating()
    }
    
    func presenterCreating() { }
}

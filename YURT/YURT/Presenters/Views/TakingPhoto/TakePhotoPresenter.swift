//
//  TakePhotoPresenter.swift
//  YURT
//
//  Created by Standret on 25.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol TakePhotoDelegate {
    
}

class TakePhotoPresenter: SttPresenter<TakePhotoDelegate> {
    
    var topMessage: String!
    var higlightMessage: String!
    var isFront = false
    
    override func prepare(parametr: Any?) {
        let param = parametr as! DocumentType
        isFront = param.needUseFrontCamera()
        higlightMessage = param.rawValue
        
        topMessage = "Align your \(param.rawValue) in the area below and press the capture button"
    }
}

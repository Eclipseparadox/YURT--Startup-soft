//
//  ShowPhotoPresenter.swift
//  YURT
//
//  Created by Standret on 04.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

protocol ShowPhotoDelegate: Viewable {
    func reloadData(type: DocumentType, image: Image)
}

class ShowPhotoPresenter: SttPresenter<ShowPhotoDelegate> {
    
    override func prepare(parametr: Any?) {
        let param = parametr as! (DocumentType, Image)
        
        delegate.reloadData(type: param.0, image: param.1)
    }
}

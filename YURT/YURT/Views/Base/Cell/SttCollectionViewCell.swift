//
//  SttCollectionViewCell.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class SttCollectionViewCell<T: ViewInjector>: UICollectionViewCell, Viewable {
    
    var dataContext: T!
    
    func sendError(error: BaseError) { }
    func sendMessage(title: String, message: String?) { }
    func close() {
        fatalError(Constants.noImplementException)
    }
    
    private var firstStart = true
    func prepareBind() {
        dataContext.injectView(delegate: self)
    }
}

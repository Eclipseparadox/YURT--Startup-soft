//
//  SttTableViewCell.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class SttTableViewCell<T: ViewInjector>: UITableViewCell, Viewable {
    
    var dataContext: T!
    
    private var firstStart = true
    func prepareBind() {
        dataContext.injectView(delegate: self)
    }
    
    func sendError(error: BaseError) {
       // fatalError(Constants.noImplementException)
    }
    func sendMessage(title: String, message: String?) {
        
    }
    func close() {
        fatalError(Constants.noImplementException)
    }
}

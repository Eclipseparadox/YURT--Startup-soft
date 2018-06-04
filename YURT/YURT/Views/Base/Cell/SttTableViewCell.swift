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
    
    func sendError(error: BaseError) { }
    func sendMessage(title: String, message: String?) { }
    func close() {
        fatalError(Constants.noImplementException)
    }
    func close(parametr: Any) {
        fatalError(Constants.noImplementException)
    }
    func navigate<TParametr, TResult>(to: String, withParametr: TParametr, callback: @escaping (TResult) -> Void) {
        fatalError(Constants.noImplementException)
    }
    func navigate(storyboardName: String, type: TypeNavigation, animated: Bool) {
        fatalError(Constants.noImplementException)
    }
    
    private var firstStart = true
    func prepareBind() {
        dataContext.injectView(delegate: self)
    }
    
    
}

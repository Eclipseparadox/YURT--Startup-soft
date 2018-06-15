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
    func navigate(to: String, withParametr: Any?, callback: ((Any) -> Void)?) {
        fatalError(Constants.noImplementException)
    }
    func navigate<T>(storyboard: Storyboard, to _: T.Type, typeNavigation: TypeNavigation, withParametr: Any?, callback: ((Any) -> Void)?) {
        fatalError(Constants.noImplementException)
    }
    func loadStoryboard(storyboard: Storyboard) {
        fatalError(Constants.noImplementException)
    }
    private var firstStart = true
    func prepareBind() {
        dataContext.injectView(delegate: self)
    }
    
    
}

//
//  SttCollectionViewCell.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class SttbCollectionViewCell: UICollectionViewCell, Viewable {
    
    var dataContext: Any!
    
    func sendError(error: BaseError) { }
    func sendMessage(title: String, message: String?) { }
    func prepareBind() {}
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
}

class SttCollectionViewCell<T: ViewInjector>: SttbCollectionViewCell {
    
    lazy var presenter: T = dataContext as! T
    
    private var firstStart = true
    override func prepareBind() {
        presenter.injectView(delegate: self)
    }
}

//
//  SttTableViewController.swift
//  YURT
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class SttTableViewController<T: ViewInjector>: UITableViewController, Viewable, KeyboardNotificationDelegate {

    func close() {
        fatalError(Constants.noImplementException)
    }
    func close(parametr: Any) {
        fatalError(Constants.noImplementException)
    }
    func sendError(error: BaseError) {
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
    func sendMessage(title: String, message: String?) {
        
    }
    
    func navigate(storyboardName: String, type: TypeNavigation = .modality, animated: Bool = true) {
        let stroyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewContrl = stroyboard.instantiateViewController(withIdentifier: "start")
        switch type {
        case .modality:
            present(viewContrl, animated: animated, completion: nil)
        case .push:
            navigationController?.pushViewController(viewContrl, animated: animated)
        }
    }
    
    var presenter: T!
    var keyboardNotification: KeyboardNotification!
    var scrollAmount: CGFloat = 0
    var scrollAmountGeneral: CGFloat = 0
    var moveViewUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardNotification = KeyboardNotification()
        keyboardNotification.callIfKeyboardIsShow = true
        keyboardNotification.delegate = self
        
        presenter = T()
        presenter.injectView(delegate: self)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClick(_:))))
    }
    
    @objc
    func handleClick(_ : UITapGestureRecognizer?) {
        view.endEditing(true)
    }
    
    func keyboardWillShow(height: CGFloat) {
        if view != nil {
            scrollAmount = height - scrollAmountGeneral
            scrollAmountGeneral = height
            
            moveViewUp = true
            scrollTheView(move: moveViewUp)
        }
    }
    func keyboardWillHide(height: CGFloat) {
        view.endEditing(true)
        if moveViewUp {
            scrollTheView(move: false)
        }
    }
    
    func scrollTheView(move: Bool) {
        // view.layoutIfNeeded()
        var frame = view.frame
        if move {
            frame.size.height -= scrollAmount
        }
        else {
            frame.size.height += scrollAmountGeneral
            scrollAmountGeneral = 0
            scrollAmount = 0
        }
        view.frame = frame
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

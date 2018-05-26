//
//  HandlerTextField.swift
//  YURT
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

enum TypeActionTextField {
    case shouldReturn
    case didEndEditing
    case editing
}

class SttHandlerTextField: NSObject, UITextFieldDelegate {
    
    // private property
    private var handlers = [TypeActionTextField:(UITextField) -> Void]()
    
    // method for add target
    
    func addTarget<T: UIViewController>(type: TypeActionTextField, delegate: T, handler: @escaping (T, UITextField) -> Void, textField: UITextField) {
        switch type {
        case .editing:
            textField.addTarget(self, action: #selector(changing), for: .editingChanged)
        default: break
        }
        handlers[type] = { [weak delegate] tf in
            if let _delegate = delegate {
                handler(_delegate, tf)
            }
        }
    }
    
    // implements protocol
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let handler = handlers[.shouldReturn]  {
            handler(textField)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let handler = handlers[.didEndEditing]  {
            handler(textField)
        }
    }
    
    @objc func changing(_ textField: UITextField) {
        if let handler = handlers[.editing]  {
            handler(textField)
        }
    }
    
    override init () {
        print ("init text handler")
    }
    
    deinit {
        print("Stt hnalder text filed deinit")
    }
}

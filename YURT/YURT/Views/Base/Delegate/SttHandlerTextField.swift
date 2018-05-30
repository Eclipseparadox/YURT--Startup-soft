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
    func addTarget(type: TypeActionTextField, handler: @escaping (UITextField) -> Void) {
        handlers[type] = handler
    }
    
    func addTarget(type: TypeActionTextField, handler: @escaping (UITextField) -> Void, textField: UITextField) {
        switch type {
        case .editing:
            textField.addTarget(self, action: #selector(changing), for: .editingChanged)
            handlers[type] = handler
        default:
            Log.error(message: "Unsupported type: \(type)", key: "SttHandlerTextField")
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
}

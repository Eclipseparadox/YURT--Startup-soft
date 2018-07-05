//
//  InputBox.swift
//  SSAnalytics
//
//  Created by Admin on 2/10/18.
//  Copyright © 2018 standret. All rights reserved.
//

import UIKit

@IBDesignable
class SimpleInputBox: SttTemplate {
    @IBOutlet weak var cnstrHeightFieldName: NSLayoutConstraint!
    @IBOutlet weak var cnstrToFieldName: NSLayoutConstraint!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var underline: UIView!
    @IBOutlet weak var error: UILabel!
    
    var errorText: String? {
        didSet {
            if (errorText != nil) {
                underline.backgroundColor = tintErrorColor
                error.text = errorText
                error.textColor = tintErrorColor
            }
        }
    }
    
    @IBInspectable
    var fieldIdentifier: String? {
        get { return fieldName.text }
        set { fieldName.text = newValue }
    }
    @IBInspectable
    var tintErrorColor: UIColor! {
        didSet {
            if (!(error.text ?? "").isEmpty) {
                error.textColor = tintActiveColor
            }
        }
    }
    @IBInspectable
    var tintActiveColor: UIColor!
    @IBInspectable
    var tintDisableColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        textField.addTarget(self, action: #selector(tfStartEditing(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(tfEndEditing(_:)), for: .editingDidEnd)
        underline.backgroundColor = tintDisableColor
        fieldName.textColor = tintDisableColor
    }
    
    @objc
    func tfStartEditing(_ tf: UITextField) {
        errorText = ""
        underline.backgroundColor = tintActiveColor
        fieldName.textColor = tintActiveColor
        
        UIView.animate(withDuration: 0.3, animations: {
            self.cnstrToFieldName.constant = 0
            self.view.layoutIfNeeded()
            })
    }
    
    @objc
    func tfEndEditing(_ tf: UITextField) {
        underline.backgroundColor = tintDisableColor
        fieldName.textColor = tintDisableColor
        
        if ((textField.text ?? "").isEmpty) {
            UIView.animate(withDuration: 0.3, animations: {
                self.cnstrToFieldName.constant = 24
                self.view.layoutIfNeeded()
                })
        }
    }
}

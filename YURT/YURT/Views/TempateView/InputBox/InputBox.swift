//
//  InputBox.swift
//  YURT
//
//  Created by Standret on 2/10/18.
//  Copyright © 2018 standret. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class InputBox: SttTemplate {
    @IBOutlet weak var cnstrHeightFieldName: NSLayoutConstraint!
    @IBOutlet weak var cnstrToFieldName: NSLayoutConstraint!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var underline: UIView!
    @IBOutlet weak var error: UILabel!
    
    var errorText: String? {
        didSet {
            error.text = errorText
            if !(errorText ?? "").trimmingCharacters(in: .whitespaces).isEmpty {
                underline.backgroundColor = tintErrorColor
            }
        }
    }
    
    @IBInspectable
    var fieldIdentifier: String? {
        get { return textField.placeholder }
        set { textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [.foregroundColor: fieldColor ?? UIColor.lightGray]) }
    }
    @IBInspectable
    var fieldColor: UIColor? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: fieldIdentifier ?? "", attributes: [.foregroundColor: fieldColor ?? UIColor.lightGray])
        }
    }
    @IBInspectable
    var tintErrorColor: UIColor! {
        didSet {
            error.textColor = tintErrorColor
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
        fieldName.isHidden = true
        
    }
    
    @objc
    func tfStartEditing(_ tf: UITextField) {
        errorText = ""
        underline.backgroundColor = tintActiveColor
        fieldName.textColor = tintActiveColor
        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.cnstrToFieldName.constant = 0
//            self.view.layoutIfNeeded()
//            })
    }
    
    @objc
    func tfEndEditing(_ tf: UITextField) {
        underline.backgroundColor = tintDisableColor
        fieldName.textColor = tintDisableColor
        
//        if ((textField.text ?? "").isEmpty) {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.cnstrToFieldName.constant = 24
//                self.view.layoutIfNeeded()
//                })
//        }
    }
}

//
//  ProfileEditItemCell.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ProfileEditItemCell: SttTableViewCell<ProfileEditItemPresenter>, ProfileEditDelegate {

    @IBOutlet weak var inputBox: SimpleInputBox!
    
    var handler = SttHandlerTextField()
    
    override func prepareBind() {
        super.prepareBind()
        
        inputBox.fieldIdentifier = presenter.identifier
        if !(presenter.value ?? "").isEmpty {
            inputBox.textField.text = presenter.value
            inputBox.tfStartEditing(inputBox.textField)
        }
        reloadError()
        
        if presenter.filed == .phone {
            inputBox.textField.keyboardType = .numberPad
        }
        else if presenter.filed == .email  {
            inputBox.textField.keyboardType = .emailAddress
        }
        else {
            inputBox.textField.keyboardType = .asciiCapable
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        handler.addTarget(type: .editing, delegate: self, handler: { [weak self] (_, t) in self?.presenter.value = t.text }, textField: inputBox.textField)
        handler.addTarget(type: .shouldReturn, delegate: self, handler: { [weak self] (_, _) in self?.presenter.onShouldReturn() }, textField: inputBox.textField)
        inputBox.textField.delegate = handler
//        inputBox.tintErrorColor = UIColor(named: "error")
//        inputBox.tintActiveColor = UIColor(named: "main")
//        inputBox.tintDisableColor = UIColor(named: "disableFeildLight")
    }
    
    // MARK: -- ProfileEditDelegate
    
    func reloadError() {
        inputBox.errorText = presenter.error.1
    }
    
    func onShouldReturn() {
        inputBox.textField.becomeFirstResponder()
    }
}

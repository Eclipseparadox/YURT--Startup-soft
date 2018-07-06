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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        handler.addTarget(type: .didEndEditing, delegate: self, handler: { [weak self] (_, a1) in self?.presenter.value = a1.text }, textField: inputBox.textField)
        inputBox.textField.delegate = handler
        inputBox.tintErrorColor = UIColor(named: "error")
        inputBox.tintActiveColor = UIColor(named: "main")
        inputBox.tintDisableColor = UIColor(named: "disableFeildLight")
    }
    
    // MARK: -- ProfileEditDelegate
    
    func reloadError() {
        inputBox.errorText = presenter.error.1
    }
    
}

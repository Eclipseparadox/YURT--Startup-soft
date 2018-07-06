//
//  ProfileEditItemCellPresenter.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol ProfileEditDelegate: SttViewable {
    func reloadError()
}

class ProfileEditItemPresenter: SttPresenter<ProfileEditDelegate> {
    
    var identifier: String!
    var filed: ValidateField!
    var callBack: (() -> Void)!
    
    var originalValue: String?
    var value: String? {
        didSet {
            error = filed.validate(rawObject: value)
            delegate?.reloadError()
            callBack()
        }
    }
    
    var isChanged: Bool { return (originalValue ?? "") != (value ?? "") }
    
    var error = (ValidationResult.ok, "")
    
    convenience init(identifier: String, value: String, field: ValidateField, callBack: @escaping () -> Void) {
        self.init()
        
        self.identifier = identifier
        self.value = value
        self.originalValue = value
        self.filed = field
        self.callBack = callBack
    }
}

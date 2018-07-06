//
//  EditProfilePresenter.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol EditProfileDelegate {
    func reloadPhoto(image: Image)
    func saveStateChanged()
}

class EditProfilePresenter: SttPresenter<EditProfileDelegate> {
    
    var data = SttObservableCollection<ProfileEditItemPresenter>()
    
    var canSave: Bool = false {
        didSet {
            delegate?.saveStateChanged()
        }
    }

    override func prepare(parametr: Any?) {
        let param = parametr as! ProfileViewModel
        
        if let img = param.profileData.image?.preview.path {
            delegate?.reloadPhoto(image: Image(url: img))
        }
        
        data.append(ProfileEditItemPresenter(identifier: "First name", value: param.profileData.firstName,
                                             field: ValidateField.firstName(nil), callBack: { [weak self] in self?.reCheckError() }))
        data.append(ProfileEditItemPresenter(identifier: "Last name", value: param.profileData.lastName,
                                             field: ValidateField.lastName(nil), callBack: { [weak self] in self?.reCheckError() }))
        data.append(ProfileEditItemPresenter(identifier: "Location", value: param.profileData.location,
                                             field: ValidateField.roleAndOrganization, callBack: { [weak self] in self?.reCheckError() }))
        data.append(ProfileEditItemPresenter(identifier: "Role and organization", value: param.profileData.work ?? "",
                                             field: ValidateField.roleAndOrganization, callBack: { [weak self] in self?.reCheckError() }))
        data.append(ProfileEditItemPresenter(identifier: "Linkedin", value: param.profileData.linkedInUrl ?? "",
                                             field: ValidateField.linkedin, callBack: { [weak self] in self?.reCheckError() }))
        data.append(ProfileEditItemPresenter(identifier: "Email", value: param.profileData.email,
                                             field: ValidateField.email(nil), callBack: { [weak self] in self?.reCheckError() }))
        data.append(ProfileEditItemPresenter(identifier: "Education", value: param.profileData.education ?? "",
                                             field: ValidateField.education, callBack: { [weak self] in self?.reCheckError() }))
    }
    
    func reCheckError() {
        var somethingChanged = false
        var isOk = true
        for item in data {
            print("\(item.isChanged) -- \(item.error.0) -- \(item.identifier)")
            somethingChanged = somethingChanged || item.isChanged
            isOk = isOk && item.error.0 == .ok
        }
        canSave = isOk && somethingChanged
    }
}

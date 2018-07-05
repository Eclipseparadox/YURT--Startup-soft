//
//  EditProfilePresenter.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol EditProfileDelegate {
    
}

class EditProfilePresenter: SttPresenter<EditProfileDelegate> {
    var data = SttObservableCollection<ProfileEditItemPresenter>()
    
    override func presenterCreating() {
        
        data.append(ProfileEditItemPresenter(identifier: "First name"))
        data.append(ProfileEditItemPresenter(identifier: "Last name"))
        data.append(ProfileEditItemPresenter(identifier: "Location"))
        data.append(ProfileEditItemPresenter(identifier: "Role and organization"))
        data.append(ProfileEditItemPresenter(identifier: "Phone"))
        data.append(ProfileEditItemPresenter(identifier: "Linkedin"))
        data.append(ProfileEditItemPresenter(identifier: "Email"))
        data.append(ProfileEditItemPresenter(identifier: "Phone"))
        data.append(ProfileEditItemPresenter(identifier: "Education"))
    }
}

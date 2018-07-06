//
//  ProfileDataModel.swift
//  YURT
//
//  Created by Standret on 06.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct ProfileViewModel {
    
    let profileData: ProfileApiModel
    var profileImage: Image?
    
    init (raw: ProfileApiModel) {
        self.profileData = raw
        if let url = profileData.image?.preview.path {
            profileImage = Image(url: url)
        }
    }
    
    func getListProfile() -> [ProfileItemPresenter] {
        var data = [ProfileItemPresenter]()
        data.append(ProfileItemPresenter(key: "Phone", value: profileData.phoneNumber))
        data.append(ProfileItemPresenter(key: "Email", value: profileData.email))
        
        if let _data = profileData.education {
            data.append(ProfileItemPresenter(key: "Education", value: _data))
        }
        if let _data = profileData.linkedInUrl {
            data.append(ProfileItemPresenter(key: "Linkedin", value: _data))
        }
        if let _data = profileData.skype {
            data.append(ProfileItemPresenter(key: "Skype", value: _data))
        }
        
        return data
    }
}

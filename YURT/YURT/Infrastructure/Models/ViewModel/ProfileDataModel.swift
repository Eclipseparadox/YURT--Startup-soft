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
        if !SttString.isWhiteSpace(string: profileData.phoneNumber) {
            data.append(ProfileItemPresenter(key: "Phone", value: profileData.phoneNumber!))
        }
        data.append(ProfileItemPresenter(key: "Email", value: profileData.email))
        
        if !SttString.isWhiteSpace(string: profileData.education) {
            data.append(ProfileItemPresenter(key: "Education", value: profileData.education!))
        }
        if !SttString.isWhiteSpace(string: profileData.linkedInUrl) {
            data.append(ProfileItemPresenter(key: "Linkedin", value: profileData.linkedInUrl!))
        }
        if !SttString.isWhiteSpace(string: profileData.skype) {
            data.append(ProfileItemPresenter(key: "Skype", value: profileData.skype!))
        }
        
        return data
    }
}

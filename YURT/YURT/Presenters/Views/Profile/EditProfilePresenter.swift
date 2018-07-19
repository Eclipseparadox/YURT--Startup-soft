//
//  EditProfilePresenter.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift
import KeychainSwift

protocol EditProfileDelegate {
    func donwloadImageComplete(isSuccess: Bool)
    func reloadPhoto(image: Image)
    func saveStateChanged()
    func saveCompleted(status: Bool)
    func hideKeyboard()
}

class EditProfilePresenter: SttPresenter<EditProfileDelegate> {
    
    var _accountService: AccountServiceType!
    var _profileInteractor: ProfileInteractorType!
    
    var data = SttObservableCollection<ProfileEditItemPresenter>()
    var photoData: ResultUploadImageApiModel?
    var isPhotoChanged: Bool = false
    
    var canSave: Bool = false {
        didSet {
            delegate?.saveStateChanged()
        }
    }
    
    var save: SttComand!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        save = SttComand(delegate: self, handler: { $0.onSave() }, handlerCanExecute: { $0.canSave })
    }

    override func prepare(parametr: Any?) {
        let param = parametr as! ProfileViewModel
        photoData = param.profileData.image
        
        if let img = param.profileData.image?.preview.path {
            delegate?.reloadPhoto(image: Image(url: img))
        }
        
        let mediator = ProfileEditMediator()
        
        data.append(ProfileEditItemPresenter(identifier: "First Name", value: param.profileData.firstName,
                                             field: ValidateField.firstName, callBack: { [weak self] in self?.reCheckError() },
                                             mediator: mediator, last: data.lastOrNil()))
        data.append(ProfileEditItemPresenter(identifier: "Last Name", value: param.profileData.lastName,
                                             field: ValidateField.lastName, callBack: { [weak self] in self?.reCheckError() },
                                             mediator: mediator, last: data.lastOrNil()))
        data.append(ProfileEditItemPresenter(identifier: "Location", value: param.profileData.location ?? "",
                                             field: ValidateField.location, callBack: { [weak self] in self?.reCheckError() },
                                             mediator: mediator, last: data.lastOrNil()))
        data.append(ProfileEditItemPresenter(identifier: "Phone", value: param.profileData.phoneNumber ?? "",
                                             field: ValidateField.phone, callBack: { [weak self] in self?.reCheckError() },
                                             mediator: mediator, last: data.lastOrNil()))
        data.append(ProfileEditItemPresenter(identifier: "Skype", value: param.profileData.skype ?? "",
                                             field: ValidateField.skype, callBack: { [weak self] in self?.reCheckError() },
                                             mediator: mediator, last: data.lastOrNil()))
        data.append(ProfileEditItemPresenter(identifier: "Role and Organization", value: param.profileData.work ?? "",
                                             field: ValidateField.roleAndOrganization, callBack: { [weak self] in self?.reCheckError() },
                                             mediator: mediator, last: data.lastOrNil()))
        data.append(ProfileEditItemPresenter(identifier: "LinkedIn", value: param.profileData.linkedInUrl ?? "",
                                             field: ValidateField.linkedin, callBack: { [weak self] in self?.reCheckError() },
                                             mediator: mediator, last: data.lastOrNil()))
        data.append(ProfileEditItemPresenter(identifier: "Email", value: param.profileData.email,
                                             field: ValidateField.email, callBack: { [weak self] in self?.reCheckError() },
                                             mediator: mediator, last: data.lastOrNil()))
        data.append(ProfileEditItemPresenter(identifier: "Education", value: param.profileData.education ?? "",
                                             field: ValidateField.education, callBack: { [weak self] in self?.reCheckError() },
                                             mediator: mediator, last: data.lastOrNil()))
        
        _ = mediator.dataObservable.subscribe(onNext: { (field) in
            if field == self.data.lastOrNil()?.filed {
                self.delegate?.hideKeyboard()
            }
        })
    }
    
    func reCheckError() {
        var somethingChanged = false
        var isOk = true
        for item in data {
            print("\(item.isChanged) -- \(item.error.0) -- \(item.identifier)")
            somethingChanged = somethingChanged || item.isChanged
            isOk = isOk && item.error.0 == .ok
        }
        canSave = isOk && (somethingChanged || isPhotoChanged)
    }
    
    private func onSave() {
        _ = save.useWork(observable: _profileInteractor.updateProfile(firstName: data[0].value!,
                                                                      lastName: data[1].value!,
                                                                      location: data[2].value!,
                                                                      phone: data[3].value!,
                                                                      skype: data[4].value,
                                                                      role: data[5].value,
                                                                      linkedin: data[6].value,
                                                                      email: data[7].value!,
                                                                      education: data[8].value,
                                                                      image: photoData))
            .subscribe(onNext: {
                KeychainSwift().set(self.data[7].value!, forKey: Constants.idEmeail)
                self.delegate?.saveCompleted(status: $0)
            }, onError: { _ in self.delegate?.saveCompleted(status: false) })
    }
    
    // MARK: -- view api
    var previusDispose: Disposable?
    func uploadImage(image: UIImage) {
        previusDispose?.dispose()
        previusDispose = _accountService.uploadUserAvatar(image: image, progresHandler: nil).subscribe(onNext: { (result) in
            self.photoData = result
            self.isPhotoChanged = true
            self.delegate!.donwloadImageComplete(isSuccess: true)
            self.reCheckError()
        }, onError: { error in
            self.delegate!.donwloadImageComplete(isSuccess: false)
        })
    }
}

//
//  ProfileViewController.swift
//  YURT
//
//  Created by Standret on 05.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol ProfileDelegate {
    func insertData()
    func reloadState(state: Bool)
}

class ProfilePresenter: SttPresenter<ProfileDelegate> {
    
    var _profileInteractor: ProfileInteractorType!
    var profileVM: ProfileViewModel!
    
    var data = SttObservableCollection<ProfileItemPresenter>()
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        _  = _profileInteractor.getProfile()
            .subscribe(onNext: { [weak self] (model) in
                self?.profileVM = model
                self?.data.append(contentsOf: model.getListProfile())
                self?.delegate?.insertData()
                self?.delegate?.reloadState(state: true)
                }, onError: { [weak self] _ in self?.delegate?.reloadState(state: false)})
    }
    
    func updateData(data: ProfileViewModel) {
        profileVM = data
        delegate?.insertData()
    }
}

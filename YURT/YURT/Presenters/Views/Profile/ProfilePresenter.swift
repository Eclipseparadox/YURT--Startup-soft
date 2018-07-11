//
//  ProfileViewController.swift
//  YURT
//
//  Created by Standret on 05.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfileDelegate: SttViewContolable {
    func insertData()
    func reloadState(state: Bool)
}

class ProfilePresenter: SttPresenter<ProfileDelegate> {
    
    var _profileInteractor: ProfileInteractorType!
    var _accountService: AccountServiceType!
    var profileVM: ProfileViewModel!
    
    var data = SttObservableCollection<ProfileItemPresenter>()
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        getProfile()
    }
    
    func updateData(data: ProfileViewModel) {
        profileVM = data
        delegate?.insertData()
    }
    
    private var dispoble: Disposable?
    func getProfile() {
        dispoble?.dispose()
        dispoble = _profileInteractor.getProfile()
            .subscribe(onNext: { [weak self] (model) in
                self?.profileVM = model
                self?.data.removeAll()
                self?.data.append(contentsOf: model.getListProfile())
                self?.delegate?.insertData()
                self?.delegate?.reloadState(state: true)
                }, onError: { [weak self] _ in self?.delegate?.reloadState(state: false)})
    }
    
    // MARK: -- API
    
    func navigateToProfile() {
        self.delegate?.navigate(to: "ProfileEdit",
                      withParametr: self.profileVM,
                      callback: { [weak self] _ in self?.getProfile() })
    }
    
    func signOut() {
        _accountService.signOut()
        delegate?.loadStoryboard(storyboard: Storyboard.login)
    }
}

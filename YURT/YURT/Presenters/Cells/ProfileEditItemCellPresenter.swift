//
//  ProfileEditItemCellPresenter.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

class ProfileEditMediator {
    
    private var publisher = PublishSubject<ValidateField>()
    var dataObservable: Observable<ValidateField> { return publisher }
    
    func publishMessage(sender: ValidateField) {
        publisher.onNext(sender)
    }
}

protocol ProfileEditDelegate: SttViewable {
    func reloadError()
    func onShouldReturn()
}

class ProfileEditItemPresenter: SttPresenter<ProfileEditDelegate> {
    
    var identifier: String!
    var filed: ValidateField!
    var callBack: (() -> Void)!
    
    private var originalValue: String?
    private var mediator: ProfileEditMediator!
    var value: String? {
        didSet {
            error = filed.validate(rawObject: value)
            delegate?.reloadError()
            callBack()
        }
    }
    
    var isChanged: Bool { return (originalValue ?? "") != (value ?? "") }
    
    var error = (ValidationResult.ok, "")
    
    convenience init(identifier: String, value: String, field: ValidateField, callBack: @escaping () -> Void, mediator: ProfileEditMediator, last: ProfileEditItemPresenter?) {
        self.init()
        
        self.mediator = mediator
        self.identifier = identifier
        self.originalValue = value
        self.filed = field
        self.callBack = callBack
        self.value = value
        
        if let _last = last {
            _ = mediator.dataObservable.subscribe(onNext: { type in
                if type == _last.filed {
                    self.delegate?.onShouldReturn()
                }
            })
        }
    }
    
    override func presenterCreating() {
        error = filed.validate(rawObject: value)
        delegate?.reloadError()
    }
    
    // MARK: -- API for view
    func onShouldReturn() {
        mediator.publishMessage(sender: filed)
    }
}

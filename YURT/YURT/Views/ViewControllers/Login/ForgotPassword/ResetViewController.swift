//
//  ResepViewController.swift
//  YURT
//
//  Created by Standret on 16.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ResetViewController: SttViewController<ResetPresenter>, ResetDelegate {

    @IBOutlet weak var inpPassword: InputBox!
    @IBOutlet weak var inpConfirmPassword: InputBox!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    
    private var passwordHandler = SttHandlerTextField()
    private var passwordConfirmHandler = SttHandlerTextField()
    
    @IBAction func onSave(_ sender: Any) {
        presenter.save.execute()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style = .lightContent
        
        inpPassword.textField.isSecureTextEntry = true
        inpConfirmPassword.textField.isSecureTextEntry = true
        
        inpPassword.textField.delegate = passwordHandler
        inpConfirmPassword.textField.delegate = passwordConfirmHandler
        
        cnstrHeight.constant = heightScreen
        
        passwordHandler.addTarget(type: .editing, delegate: self, handler: { $0.presenter.password = $1.text ?? "" }, textField: inpPassword.textField)
        passwordHandler.addTarget(type: .shouldReturn, delegate: self, handler: { (view, _) in view.inpConfirmPassword.textField.becomeFirstResponder() }, textField: inpPassword.textField)
        
        passwordConfirmHandler.addTarget(type: .editing, delegate: self, handler: { $0.presenter.passwordConfirm = $1.text ?? "" }, textField: inpConfirmPassword.textField)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.save.useIndicator(button: btnSave)
    }
}

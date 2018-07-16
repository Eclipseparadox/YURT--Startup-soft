//
//  ForgotPasswordViewController.swift
//  YURT
//
//  Created by Standret on 11.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: SttViewController<ForgotPasswordPresenter>, ForgotPasswordDelegate {

    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    @IBOutlet weak var inpEmail: InputBox!
    @IBOutlet weak var btnReset: UIButton!
    
    @IBAction func onResetPassword(_ sender: Any) {
        presenter.email = inpEmail.textField.text ?? ""
        presenter.reset.execute()
    }
    
    let handlerEmail = SttHandlerTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style = .lightContent
        cnstrHeight.constant = heightScreen - 64
        
        handlerEmail.addTarget(type: .didEndEditing, delegate: self, handler: { $0.presenter.email = $1.text ?? "" }, textField: inpEmail.textField)
        
        inpEmail.textField.delegate = handlerEmail
        inpEmail.textField.keyboardType = .emailAddress
    }
    
    private var firstStart = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstStart {
            presenter.reset.useIndicator(button: btnReset)
            firstStart = false
        }
    }
    
    // MARK: -- ForgotPasswordDelegate
    
    func reloadError() {
        inpEmail.errorText = presenter.emailError.1
    }
}

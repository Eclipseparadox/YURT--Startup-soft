//
//  RejectOfferViewController.swift
//  YURT
//
//  Created by Standret on 27.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

extension UIButton {
    func setEnabled(isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.alpha = isEnabled ? 1.0 : 0.5
    }
}

class RejectOfferViewController: SttViewController<RejectOfferPresenter>, RejectOfferDelegate {
    
    func removePreviewVC() {
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeLast(2) // views to pop
        navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblFulname: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var viewTvBackground: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var cnstrHintHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var tvHandler = SttHandlerTextView()
    
    @IBAction func sendClick(_ sender: Any) {
        presenter.send.execute()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.loadImage(image: Image(url: presenter.data.lender.image.preview.path))
        lblFulname.text = presenter.data.lender.fullName
        lblLocation.text = presenter.data.lender.mailingAddress
        imgProfile.createCircle()

        cnstrHintHeight.constant = 0
        tvComment.delegate = tvHandler
        tvHandler.addTarget(type: .didBeginEditing, delegate: self, handler: { (vc, _) in
            vc.viewTvBackground.layer.borderColor = UIColor(named: "main")!.cgColor
            vc.cnstrHintHeight.constant = 30
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        }, textField: tvComment)
        tvHandler.addTarget(type: .didEndEditing, delegate: self, handler: {
            (vc, _) in vc.viewTvBackground.layer.borderColor = UIColor(named: "borderLight")!.cgColor
            vc.cnstrHintHeight.constant = 0
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        }, textField: tvComment)
        tvHandler.addTarget(type: .editing, delegate: self, handler: { $0.presenter.comment = $1.text }, textField: tvComment)
        
        viewTvBackground.setBorder(color: UIColor(named: "borderLight")!, size: 1)
        btnSend.layer.cornerRadius = 5
        
        btnSend.setEnabled(isEnabled: false)
    }
    
    override func keyboardWillShow(height: CGFloat) {
        super.keyboardWillShow(height: height)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.btnSend.bounds.maxY + self.btnSend.bounds.height), animated: true)
        }
    }
    
    func reloadSendState() {
        btnSend.setEnabled(isEnabled: presenter.send.canExecute())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.send.useIndicator(button: btnSend)
    }
}

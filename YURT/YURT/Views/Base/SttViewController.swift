//
//  SttViewController.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ErrorLabel: UIView {
    private var errorLabel: UILabel!
    private var topContraint: NSLayoutConstraint!
    
    weak var delegate: UIViewController! {
        didSet {
            injectConponnent()
        }
    }
    
    func showError(text: String) {
        errorLabel.text = text
        topContraint.constant = 0
        UIView.animate(withDuration: 0.5, animations: { [weak self] in self?.delegate.view?.layoutIfNeeded() })
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] (timer) in
            timer.invalidate()
            self?.topContraint.constant = CGFloat(UIConstants.heightErrorLabel)
            UIView.animate(withDuration: 0.5, animations: { [weak self] in self?.delegate.view?.layoutIfNeeded() })
        }
    }
    
    @objc func onClick(_ sender: Any) {
        
    }
    
    private func injectConponnent() {
        backgroundColor = UIColor(named: "labelError")
        translatesAutoresizingMaskIntoConstraints = false
        delegate.view.addSubview(self)
        topContraint = NSLayoutConstraint(item: delegate.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 40)
        delegate.view.addConstraints([
            topContraint,
            NSLayoutConstraint(item: delegate.view, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: delegate.view, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
            ])
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(UIConstants.heightErrorLabel)))
        
        errorLabel = UILabel()
        errorLabel.textColor = UIColor.white
        errorLabel.font = UIFont(name: "Roboto-Regular", size: 14)!
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        
        self.addSubview(errorLabel)
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: errorLabel, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: errorLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: errorLabel, attribute: NSLayoutAttribute.left, multiplier: 1, constant: -15),
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: errorLabel, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 15)
            ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
    }
}

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.index(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}

enum TypeNavigation {
    case push
    case modality
}

protocol Viewable: class {
    func sendMessage(title: String, message: String?)
    func sendError(error: BaseError)
    func close()
    func close(parametr: Any)
    func navigate(to: String, withParametr: Any, callback: @escaping (Any) -> Void)
    func navigate(storyboardName: String, type: TypeNavigation, animated: Bool)
}

protocol ViewInjector {
    func injectView(delegate: Viewable)
    func prepare(parametr: Any?)
    init()
}

class SttbViewController: UIViewController, KeyboardNotificationDelegate {
    
    fileprivate var parametr: Any?
    fileprivate var callback: ((Any) -> Void)?
    
    var keyboardNotification: KeyboardNotification!
    var scrollAmount: CGFloat = 0
    var scrollAmountGeneral: CGFloat = 0
    var moveViewUp: Bool = false
    var style = UIStatusBarStyle.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardNotification = KeyboardNotification()
        keyboardNotification.callIfKeyboardIsShow = true
        keyboardNotification.delegate = self
    }
    
    func keyboardWillShow(height: CGFloat) {
        if view != nil {
            scrollAmount = height - scrollAmountGeneral
            scrollAmountGeneral = height
            
            moveViewUp = true
            scrollTheView(move: moveViewUp)
        }
    }
    func keyboardWillHide(height: CGFloat) {
        if moveViewUp {
            scrollTheView(move: false)
        }
        view.endEditing(true)
    }
    
    func scrollTheView(move: Bool) {
        // view.layoutIfNeeded()
        var frame = view.frame
        if move {
            frame.size.height -= scrollAmount
        }
        else {
            frame.size.height += scrollAmountGeneral
            scrollAmountGeneral = 0
            scrollAmount = 0
        }
        view.frame = frame
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

class SttViewController<T: ViewInjector>: SttbViewController, Viewable {
    
    var presenter: T!
    
    var heightScreen: CGFloat { return UIScreen.main.bounds.height }
    var widthScreen: CGFloat { return UIScreen.main.bounds.width }
    var hideNavigationBar = false
    var hideTabBar = false
    
    private var viewError: ErrorLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = T()//.init(delegate: self)
        presenter.injectView(delegate: self)
        presenter.prepare(parametr: parametr)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClick(_:))))

        _ = GlobalObserver.observableStatusApplication.subscribe(onNext: { (status) in
            if status == ApplicationStatus.EnterBackgound {
                self.view.endEditing(true)
                self.navigationController?.navigationBar.endEditing(true)
            }
        })
        
        viewError = ErrorLabel()
        view.addSubview(viewError)
        viewError.delegate = self
    }
    
    @objc
    func handleClick(_ : UITapGestureRecognizer?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardNotification.addObserver()
        UIApplication.shared.statusBarStyle = style
        navigationController?.setNavigationBarHidden(hideNavigationBar, animated: true)
        navigationController?.navigationController?.navigationBar.isHidden = hideNavigationBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardNotification.removeObserver()
        navigationController?.navigationController?.navigationBar.isHidden = false
    }
    
    func sendError(error: BaseError) {
        let serror = error.getMessage()
        viewError.showError(text: serror.0)
        
        //self.createAlerDialog(title: serror.0, message: serror.1)
    }
    func sendMessage(title: String, message: String?) {
        self.createAlerDialog(title: title, message: message!)
    }
    
    func close(animate: Bool = true) {
        if self.isModal {
            dismiss(animated: animate, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: animate)
        }
    }
    func close(parametr: Any, animate: Bool = true) {
        callback?(parametr)
        close(animate: animate)
    }
    func close() {
        close(animate: true)
    }
    func close(parametr: Any) {
        close(parametr: parametr, animate: true)
    }
    
    
    func navigate(storyboardName: String, type: TypeNavigation = .modality, animated: Bool = true) {
        let stroyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewContrl = stroyboard.instantiateViewController(withIdentifier: "start")
        switch type {
        case .modality:
            present(viewContrl, animated: animated, completion: nil)
        case .push:
            navigationController?.pushViewController(viewContrl, animated: animated)
        }
    }

    
    private var navigateData: (String, Any, (Any) -> Void)?
    func navigate(to: String, withParametr: Any, callback: @escaping (Any) -> Void) {
        navigateData = (to, withParametr, callback)
        performSegue(withIdentifier: to, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let  navDatra = navigateData {
            if segue.identifier == navDatra.0 {
                let previewC = segue.destination as! SttbViewController
                previewC.parametr = navigateData?.1
                previewC.callback = navigateData?.2
                navigateData = nil
            }
        }
    }
}

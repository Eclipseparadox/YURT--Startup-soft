//
//  SttViewController.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

enum TypeNavigation {
    case push
    case modality
}

enum Storyboard: String {
    case main = "Main"
    case photo = "Photo"
    case offer = "Offer"
    case login = "Login"
    case none
}

protocol Viewable: class {
    func sendMessage(title: String, message: String?)
    func sendError(error: BaseError)
    func close()
    func close(parametr: Any)
    func navigate(to: String, withParametr: Any?, callback: ((Any) -> Void)?)
    func navigate<T>(storyboard: Storyboard, to _: T.Type, typeNavigation: TypeNavigation, withParametr: Any?, callback: ((Any) -> Void)?)
    func loadStoryboard(storyboard: Storyboard)
}

extension Viewable {
    func navigate(to: String, withParametr: Any? = nil, callback: ((Any) -> Void)? = nil) {
        self.navigate(to: to, withParametr: withParametr, callback: callback)
    }
    func navigate<T>(storyboard: Storyboard, to _: T.Type, typeNavigation: TypeNavigation = .push, withParametr: Any? = nil, callback: ((Any) -> Void)? = nil) {
        self.navigate(storyboard: storyboard, to: T.self, typeNavigation: typeNavigation, withParametr: withParametr, callback: callback)
    }
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
    
    func navigate<T>(storyboard: Storyboard, to _: T.Type, typeNavigation: TypeNavigation, withParametr: Any?, callback: ((Any) -> Void)?)  {
        let bundle = Bundle(for: type(of: self))
        let _nibName = "\(type(of: T.self))".components(separatedBy: ".").first!
        let nibName = String(_nibName[..<(_nibName.index(_nibName.endIndex, offsetBy: -9))])
        
        var vc: SttbViewController!
        if storyboard == .none {
            fatalError("unsupported operation")
        }
        else {
            let stroyboard = UIStoryboard(name: storyboard.rawValue, bundle: bundle)
            vc = stroyboard.instantiateViewController(withIdentifier: nibName) as! SttbViewController
            vc.parametr = withParametr
            vc.callback = callback
        }
        switch typeNavigation {
        case .modality:
            present(vc, animated: true, completion: nil)
        case .push:
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func loadStoryboard(storyboard: Storyboard) {
        let stroyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let vc = stroyboard.instantiateViewController(withIdentifier: "start")
        present(vc, animated: true, completion: nil)
    }
    
    private var navigateData: (String, Any?, ((Any) -> Void)?)?
    func navigate(to: String, withParametr: Any?, callback: ((Any) -> Void)?) {
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

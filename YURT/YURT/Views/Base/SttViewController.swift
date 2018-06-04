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
        view.endEditing(true)
        if moveViewUp {
            scrollTheView(move: false)
        }
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
    }
    
    @objc
    func handleClick(_ : UITapGestureRecognizer?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = style
        navigationController?.setNavigationBarHidden(hideNavigationBar, animated: true)
    }
    
    func sendError(error: BaseError) {
        let serror = error.getMessage()
        self.createAlerDialog(title: serror.0, message: serror.1)
    }
    func sendMessage(title: String, message: String?) {
        self.createAlerDialog(title: title, message: message!)
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    func close(parametr: Any) {
        callback?(parametr)
        close()
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

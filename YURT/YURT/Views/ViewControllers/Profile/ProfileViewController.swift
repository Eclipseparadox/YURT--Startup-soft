//
//  ProfileViewController.swift
//  YURT
//
//  Created by Standret on 05.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import KeychainSwift
import RealmSwift
import RxSwift

enum DocumentsLoaderError: Error, SttBaseErrorType {
    
    case unsupportedDocument(String)
    case incorrectUrl
    
    func getMessage() -> (String, String) {
        var message: (String, String)!
        switch self {
        case .incorrectUrl:
            message = ("urlIsNill", "")
        case .unsupportedDocument(let mess):
            message = ("unsupportedDocumentType", "of type: \(mess)")
        }
        return message
    }
}

class DocumentsPreviewImageLoader: NSObject, UIWebViewDelegate {
    
    private var webView: UIWebView?
    
    private var publisher = PublishSubject<UIImage?>()
    var observable: Observable<UIImage?> { return publisher }
    
    func load(fileURLString: String) {
        if ["pdf", "doc", "docx"].contains(fileURLString.components(separatedBy: ".").last!.lowercased()) {
            if let url = URL(string: fileURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                webView = UIWebView(frame: CGRect(x: 20, y: 20, width: 500, height: 666))
                webView?.delegate = self
                webView!.loadRequest(URLRequest(url: url))
            }
            else {
                publisher.onError(DocumentsLoaderError.incorrectUrl)
            }
        }
        else {
            publisher.onError(DocumentsLoaderError.unsupportedDocument(fileURLString.components(separatedBy: ".").last!.lowercased()))
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIGraphicsBeginImageContext(CGSize(width: 500, height: 666))
        let context = UIGraphicsGetCurrentContext()
        webView.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        publisher.onNext(image)
        publisher.onCompleted()
        publisher.dispose()
    }
}

class ProfileViewController: SttViewController<ProfilePresenter>, ProfileDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var dataCollection: UITableView!
    var editButton: UIBarButtonItem!
    
    var statusUpdatedIndicator: UIActivityIndicatorView!

    var dataSource: SttTableViewSource<ProfileItemPresenter>!
    
    @objc func onEdit(_ sender: Any) {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionController.addAction(UIAlertAction(title: "Edit your profile", style: .default, handler: { (x) in
            self.presenter.navigateToProfile()
        }))
        actionController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (x) in
            self.presenter.signOut()
        }))
        actionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionController, animated: true, completion: nil)
    }
    
    
    private var shadowImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style = .lightContent
        
        imgProfile.createCircle()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        shadowImage = navigationController?.navigationBar.shadowImage
        navigationController?.view.backgroundColor = UIColor.clear
        
        dataSource = SttTableViewSource(tableView: dataCollection,
                                        cellIdentifiers: [SttIdentifiers(identifers: UIConstants.CellName.profileItemCell, nibName: nil)],
                                        collection: presenter.data)
        dataCollection.dataSource = dataSource
        
        let data = SttDefaultComponnents.createBarButtonLoader()
        statusUpdatedIndicator = data.1
        statusUpdatedIndicator.color = UIColor.white
        navigationItem.rightBarButtonItem = nil
        navigationItem.setRightBarButton(data.0, animated: true)
        editButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(onEdit(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.shadowImage = shadowImage
    }
    
    func insertData() {
        if let img = presenter.profileVM.profileImage {
            imgProfile.loadImage(image: img)
        }
        lblFullName.text = "\(presenter.profileVM.profileData.firstName) \(presenter.profileVM.profileData.lastName)"
        lblLocation.text = presenter.profileVM.profileData.location
        lblPosition.text = presenter.profileVM.profileData.work ?? "Currently not Employed"
    }
    
    func reloadState(state: Bool) {
        navigationItem.rightBarButtonItem = nil
        navigationItem.setRightBarButton(editButton, animated: true)
    }
}

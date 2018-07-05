//
//  ProfileEditViewController.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ProfileEditViewController: SttViewController<EditProfilePresenter>, EditProfileDelegate {

    @IBOutlet weak var camreView: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var iconCamare: UIImageView!
    @IBOutlet weak var dataCollection: UITableView!
    @IBOutlet weak var cnstrTableView: NSLayoutConstraint!
    
    var source: SttTableViewSource<ProfileEditItemPresenter>!
    
    var indicatorImage: UIActivityIndicatorView!
    var saveButton: UIBarButtonItem!
    var btnIndicator: UIBarButtonItem!
    
    var cameraPicker: SttCamera!
    
    @IBAction func changePhotoClick(_ sender: Any) {
        cameraPicker.showPopuForDecision()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorImage = maskView.setIndicator()
        indicatorImage.color = UIColor.white
        
        let loaderData = SttDefaultComponnents.createBarButtonLoader()
        btnIndicator = loaderData.0
        loaderData.1.startAnimating()
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(onSave(_:)))
        saveButton.tintColor = UIColor(named: "main")
        navigationItem.setRightBarButton(saveButton, animated: true)
        
        cameraPicker = SttCamera(parent: self, handler: { [weak self] (image) in
            
            self?.imgPhoto.isHidden = false
            self?.imgPhoto.image = image
            self?.maskView.isHidden = false
            self?.indicatorImage.startAnimating()
            //self?.btnSignUp.isEnabled = false
            //self?.presenter.uploadImage(image: image)
        })
        
        camreView.createCircle()
        camreView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickOnPhoto(_:))))
        
        style = .default

        source = SttTableViewSource(tableView: dataCollection, cellIdentifiers: [SttIdentifiers(identifers: "ProfileEditItemCell", nibName: nil)], collection: presenter.data)
        dataCollection.dataSource = source
        cnstrTableView.constant = 70 * CGFloat(presenter.data.count)
    }
    
    @objc func onClickOnPhoto(_ send: Any) {
        cameraPicker.showPopuForDecision()
    }
    @objc func onSave(_ send: Any) {
        navigationItem.rightBarButtonItem = nil
        self.navigationItem.setRightBarButton(btnIndicator, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.tintColor = UIColor.black
    }
}

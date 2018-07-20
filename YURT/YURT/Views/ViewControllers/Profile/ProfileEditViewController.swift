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
        isClosed = false
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
        saveButton.isEnabled = false
        navigationItem.setRightBarButton(saveButton, animated: true)
        
        cameraPicker = SttCamera(parent: self, handler: { [weak self] (image) in
            self?.saveButton.isEnabled = false
            self?.imgPhoto.isHidden = false
            self?.imgPhoto.image = image
            self?.maskView.isHidden = false
            self?.indicatorImage.startAnimating()
            self?.saveButton.isEnabled = false
            self?.iconCamare.isHidden = true
            self?.presenter.uploadImage(image: image)
        })
        
        camreView.createCircle()
        camreView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickOnPhoto(_:))))
        
        style = .default

        source = SttTableViewSource(tableView: dataCollection,
                                    cellIdentifiers: [SttIdentifiers(identifers: "ProfileEditItemCell", nibName: nil)],
                                    collection: presenter.data)
        dataCollection.dataSource = source
        cnstrTableView.constant = 74 * CGFloat(presenter.data.count)
        
        let newBackButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(onBackBarButton(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func onBackBarButton(_ send: Any) {
        view.endEditing(true)
        if presenter.canSave {
            let actionController = UIAlertController(title: nil, message: "Are you sure you want to continue?\nChanges will not be saved", preferredStyle: .actionSheet)
            actionController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (x) in
                self.close(animated: true)
            }))
            actionController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            present(actionController, animated: true, completion: nil)
        }
        self.close(animated: true)
    }
    
    @objc func onClickOnPhoto(_ send: Any) {
        cameraPicker.showPopuForDecision()
    }
    @objc func onSave(_ send: Any) {
        self.navigationItem.setRightBarButton(btnIndicator, animated: true)
        self.presenter.save.execute()
    }
    
    private var isClosed = true
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isClosed = true
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MARK: -- EditProfileDelegate
    
    func reloadPhoto(image: Image) {
        imgPhoto.loadImage(image: image)
    }
    
    func saveStateChanged() {
        self.saveButton.isEnabled =  self.presenter.canSave
    }
    
    func donwloadImageComplete(isSuccess: Bool) {
        indicatorImage.stopAnimating()
        maskView.isHidden = true
        if !isSuccess {
            self.imgPhoto.image = UIImage(named: "placeholder")
        }
    }

    func saveCompleted(status: Bool) {
        if status {
            self.close(parametr: true)
        }
        else {
            self.navigationItem.setRightBarButton(saveButton, animated: true)
        }
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
}

//
//  ShowPhotoViewController.swift
//  YURT
//
//  Created by Standret on 04.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ShowPhotoViewController: SttViewController<ShowPhotoPresenter>, ShowPhotoDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cnstrBottomImage: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func close(_ sender: Any) {
        close(parametr: false)
    }
    @IBAction func btnDelete(_ sender: Any) {
        presenter.deleteCommand.execute()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style = .lightContent
        btnDelete.createCircle()
        presenter.deleteCommand.useIndicator(button: btnDelete)
        presenter.deleteCommand.addHandler(start: {
            self.btnClose.isEnabled = false
        }) {
            self.btnClose.isEnabled = true
        }
    }
    
    func reloadData(title: String, image: Image) {
        imgView.loadImage(image: image)
        lblTitle.text = title
        
        if presenter.id == nil {
            btnDelete.isHidden = true
        }
    }
}

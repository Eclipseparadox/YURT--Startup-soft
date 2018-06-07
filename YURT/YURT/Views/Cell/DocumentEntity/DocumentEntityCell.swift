 //
//  DocumentEntityCell.swift
//  YURT
//
//  Created by Standret on 31.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

 class DocumentEntityCell: SttCollectionViewCell<DocumentEntityPresenter>, DocumentEntityDelegate {

    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocType: UILabel!
    @IBOutlet weak var lblDocDate: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    func donwloadImageComplete(isSuccess: Bool) {
        viewLoading.isHidden = true
    }
    func changeProgress(label: String) {
        viewLoading.isHidden = false
        lblPercent.text = label
    }
    
    
    override func prepareBind() {
        indicator.startAnimating()
        super.prepareBind()
        layer.cornerRadius = 4
        clipsToBounds = true
        
        layer.borderColor = UIColor(named: "border")!.cgColor
        layer.borderWidth = 1
        
        imgDocument.loadImage(image: presenter.image!)
        lblDocType.text = presenter.documentsName
        
        lblDocDate.text = presenter.takesDate == nil ? "-" : DateConverter().convert(value: presenter.takesDate!)
        
        isUserInteractionEnabled = true
        imgDocument.isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
    }
    
    @objc func onClick(_ sender: Any) {
        presenter.clickOnItem()
    }
}

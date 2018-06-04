 //
//  DocumentEntityCell.swift
//  YURT
//
//  Created by Standret on 31.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class DocumentEntityCell: SttCollectionViewCell<DocumentEntityPresenter>, DocumentEntityDelegate {

    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocType: UILabel!
    @IBOutlet weak var lblDocDate: UILabel!
    
    override func prepareBind() {
        layer.cornerRadius = 4
        clipsToBounds = true
        
        layer.borderColor = UIColor(named: "border")!.cgColor
        layer.borderWidth = 1
        
        if let imgData = presenter.image?.data {
          imgDocument.image = UIImage(data: imgData)
        }
        if let image = presenter.image?.image {
            imgDocument.image = image
        }
        lblDocType.text = presenter.documentsName
        
        lblDocDate.text = DateConverter().convert(value: presenter.takesDate)
        
        isUserInteractionEnabled = true
        imgDocument.isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
    }
    
    @objc func onClick(_ sender: Any) {
        presenter.clickOnItem()
    }
}

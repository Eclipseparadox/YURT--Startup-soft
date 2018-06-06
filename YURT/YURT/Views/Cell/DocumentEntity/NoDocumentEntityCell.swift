//
//  NoDocumentEntityCell.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class NoDocumentEntityCell: SttCollectionViewCell<DocumentEntityPresenter>, DocumentEntityDelegate {

    @IBOutlet weak var lblType: UILabel!
    
    override func prepareBind() {
        layer.cornerRadius = 4
        clipsToBounds = true
        
        layer.borderColor = UIColor(named: "border")!.cgColor
        layer.borderWidth = 1
        
        lblType.text = presenter.documentType.rawValue
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
    }

    @objc func onClick(_ sender: Any) {
        presenter.clickOnItem()
    }
    
    func donwloadImageComplete(isSuccess: Bool) { }
    func changeProgress(label: String) { }
}

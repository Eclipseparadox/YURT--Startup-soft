//
//  DocumentEntityHeaderView.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class DocumentEntityHeaderView: SttTCollectionReusableView<DocumentsEntityHeaderPresenter>, DocumentsEntityHeaderDelegate {
        
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var imgError: UIImageView!
        
    override func prepareBind() {
        lblTitle.text = dataContext.title
        lblCounter.text = "\(dataContext.uploadedsCount)/\(dataContext.totalCountDocument!)"
        imgError.isHidden = !(dataContext?.isError ?? false)
    }
}

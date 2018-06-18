//
//  DocumentLenderCell.swift
//  YURT
//
//  Created by Standret on 18.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class DocumentLenderCell: SttCollectionViewCell<DocumentLenderCellPresenter>, DocumentLenderCellDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 2
        self.setBorder(color: UIColor(named: "border")!, size: 1)
    }

}

//
//  OfferDetailTableViewCell.swift
//  YURT
//
//  Created by Standret on 18.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class OfferDetailTableViewCell: SttTableViewCell<OfferDetailPresenter>, OfferDetailDelegate {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func prepareBind() {
        super.prepareBind()
        
        name.text = presenter.name
        value.text = ViewOfferDetailConverter().convert(value: (presenter.value, presenter.type))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

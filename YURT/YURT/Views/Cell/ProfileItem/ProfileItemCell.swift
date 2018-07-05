//
//  ProfileItemTableViewCell.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ProfileItemCell: SttTableViewCell<ProfileItemPresenter> {

    @IBOutlet weak var lvlType: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func prepareBind() {
        super.prepareBind()
        
        lvlType.text = presenter.key
        lblValue.text = presenter.value
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

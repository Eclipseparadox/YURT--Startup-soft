//
//  ProfileEditItemCell.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ProfileEditItemCell: SttTableViewCell<ProfileEditItemPresenter> {

    @IBOutlet weak var inputBox: SimpleInputBox!
    
    override func prepareBind() {
        super.prepareBind()
        
        inputBox.fieldIdentifier = presenter.identifier
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //inputBox.fieldColor = UIColor(named: "disableField")
        inputBox.tintErrorColor = UIColor(named: "error")
        inputBox.tintActiveColor = UIColor(named: "main")
        inputBox.tintDisableColor = UIColor(named: "disableFeildLight")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

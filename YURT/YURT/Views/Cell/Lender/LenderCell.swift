//
//  LenderCell.swift
//  YURT
//
//  Created by Standret on 12.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class LenderCell: SttTableViewCell<LenderPresenter>, LenderDelegate {

    @IBOutlet weak var mainBorder: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblYears: UILabel!
  
    override func prepareBind() {
        
    }
    
    override func awakeFromNib() {
        mainBorder.layer.cornerRadius = 5
        mainBorder.layer.borderWidth = 1
        mainBorder.layer.borderColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1).cgColor
        mainBorder.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainBorder.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.05).cgColor
        mainBorder.layer.shadowOpacity = 1
        mainBorder.layer.shadowRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

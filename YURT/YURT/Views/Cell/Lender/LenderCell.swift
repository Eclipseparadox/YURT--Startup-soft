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
    @IBOutlet weak var lblLocation: UILabel!
    
    override func prepareBind() {
        imgProfile.loadImage(image: Image(url: presenter.data.lender.image.preview.path))
        lblFullName.text = presenter.data.lender.fullName
        lblLocation.text = presenter.data.lender.mailingAddress
        imgProfile.createCircle()
        
        lblRate.text = "\(presenter.data.rate)%"
        lblAmount.text = "$ \(presenter.data.downPayment.formattedWithSeparator)"
        lblYears.text = CountableConverter().convert(value: (presenter.data.term, "month"))
    }
    
    override func awakeFromNib() {
        mainBorder.layer.cornerRadius = 5
        mainBorder.layer.borderWidth = 1
        mainBorder.layer.borderColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1).cgColor
        mainBorder.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainBorder.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.05).cgColor
        mainBorder.layer.shadowOpacity = 1
        mainBorder.layer.shadowRadius = 5
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickOnItem(_:))))
    }
    
    @objc func onClickOnItem(_ sender: Any) {
        presenter.openOffers()
    }
}

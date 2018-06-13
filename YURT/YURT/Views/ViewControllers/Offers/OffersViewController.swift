//
//  OffersViewController.swift
//  YURT
//
//  Created by Standret on 12.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class OffersViewController: UIViewController {
    
    @IBOutlet weak var viewPager: SttViewPager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPager.parent = self
        viewPager.heightTabBar = 44

        let newVC = NewLendersViewController(nibName: "NewLendersViewController", bundle: nil)
        let revieserVC = ReviserLendersViewController(nibName: "ReviserLendersViewController", bundle: nil)
        let approvedVC = ApprovedLendersViewController(nibName: "ApprovedLendersViewController", bundle: nil)
        let rejectedVC = RejectedLendersViewController(nibName: "RejectedLendersViewController", bundle: nil)
        
        viewPager.addItem(view: newVC, title: "New")
        viewPager.addItem(view: revieserVC, title: "Reviser")
        viewPager.addItem(view: approvedVC, title: "Approved")
        viewPager.addItem(view: rejectedVC, title: "Rejected")
    }
}

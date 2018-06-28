//
//  OffersViewController.swift
//  YURT
//
//  Created by Standret on 15.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import RxSwift

class OffersViewController: UIViewController {
    
    private var bus = PublishSubject<OfferStatus?>()
    
    private var statusUpdatedIndicator: UIActivityIndicatorView!
    private var calledChild = Set<OfferStatus>()

    @IBOutlet weak var viewPager: SttViewPager!
    override func viewDidLoad() {
        
        let loaderData = SttDefaultComponnents.createBarButtonLoader()
        self.navigationItem.setRightBarButton(loaderData.0, animated: true)
        statusUpdatedIndicator = loaderData.1
        
        super.viewDidLoad()

        viewPager.parent = self
        viewPager.heightTabBar = 44
        
        calledChild.insert(.approved)
        calledChild.insert(.approved)
        calledChild.insert(.pending)
        calledChild.insert(.pending)
        calledChild.insert(.rejected)
        
        let newVC = NewLendersViewController(nibName: "NewLendersViewController", bundle: nil)
        newVC.insertParametr(parametr: bus)
        //let revieserVC = ReviserLendersViewController(nibName: "ReviserLendersViewController", bundle: nil)
        let approvedVC = ApprovedLendersViewController(nibName: "ApprovedLendersViewController", bundle: nil)
        approvedVC.insertParametr(parametr: bus)
        let rejectedVC = RejectedLendersViewController(nibName: "RejectedLendersViewController", bundle: nil)
        rejectedVC.insertParametr(parametr: bus)
        
        _ = bus.subscribe(onNext: { [weak self] status in
            if let _stat = status {
                self?.calledChild.insert(_stat)
                if self?.calledChild.count == 3 {
                    self?.statusUpdatedIndicator.stopAnimating()
                    self?.calledChild.removeAll()
                }
            }
        })
        
        print("--> \(newVC.presenter)")
        
        viewPager.addItem(view: newVC, title: "New")
        viewPager.addItem(view: approvedVC, title: "Approved")
        viewPager.addItem(view: rejectedVC, title: "Rejected")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statusUpdatedIndicator.startAnimating()
        bus.onNext(nil)
    }
}

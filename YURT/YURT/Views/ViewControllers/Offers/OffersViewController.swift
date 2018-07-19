//
//  OffersViewController.swift
//  YURT
//
//  Created by Standret on 15.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import RxSwift

class OffersViewController: SttViewController<OfferPresenter>, OfferDelegate {
    
    private var bus = PublishSubject<OfferStatus?>()
    
    private var statusUpdatedIndicator: UIActivityIndicatorView!
    private var calledChild = Set<OfferStatus>()
    
    var generalLoaderView = SttLoaderView()

    @IBOutlet weak var viewPager: SttViewPager!
    override func viewDidLoad() {
        
//        let loaderData = SttDefaultComponnents.createBarButtonLoader()
//        self.navigationItem.setRightBarButton(loaderData.0, animated: true)
//        statusUpdatedIndicator = loaderData.1
        
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
                if _stat != OfferStatus.updateConuter {
                    self?.calledChild.insert(_stat)
                    if self?.calledChild.count == 3 {
                        //self?.statusUpdatedIndicator.stopAnimating()
                        self?.generalLoaderView.isLoading = false
                        self?.calledChild.removeAll()
                    }
                }
                else {
                    self?.presenter.reloadCount()
                }
            }
        })
        
        print("--> \(newVC.presenter)")
        
        viewPager.addItem(view: newVC, title: "New")
        viewPager.addItem(view: approvedVC, title: "Approved")
        viewPager.addItem(view: rejectedVC, title: "Rejected")
        
        generalLoaderView.delegate = self
    }
    
    private var isFirstStart = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.reloadCount()
        //generalLoaderView.isLoading = true
        //statusUpdatedIndicator.startAnimating()
        if isFirstStart {
            isFirstStart = false
            bus.onNext(nil)
        }
    }
    
    // MARK: -- OfferDelegate
    
    func reloadCounter(data: OfferCountApiModel) {
        viewPager.segmentControl.setTitle("New (\(data.allNewOffersCount))", forSegmentAt: 0)
        viewPager.segmentControl.setTitle("Approved (\(data.allApprovedOffersCount))", forSegmentAt: 1)
        viewPager.segmentControl.setTitle("Rejected (\(data.allRejectedOffersCount))", forSegmentAt: 2)
    }
}

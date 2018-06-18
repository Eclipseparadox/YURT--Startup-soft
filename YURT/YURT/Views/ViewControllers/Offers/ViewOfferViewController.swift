//
//  ViewOfferViewController.swift
//  YURT
//
//  Created by Standret on 15.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

extension UITextView {
    func resize() {
        let fixWidth = self.frame.size.width
        let size = self.sizeThatFits(CGSize(width: fixWidth, height: 2000))
        self.frame.size = CGSize(width: max(fixWidth, size.width), height: size.height)
    }
}

class ViewOfferViewController: SttViewController<ViewOfferPresenter>, ViewOfferDelegate {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var offerDetailCollection: UITableView!
    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var cnstrTvHeight: NSLayoutConstraint!
    @IBOutlet weak var documentCollection: UICollectionView!
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    var offerDetailSource: SttTableViewSource<OfferDetailPresenter>!
    var documentSource: SttCollectionSource<DocumentLenderCellPresenter>!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        imgProfile.createCircle()
        imgProfile.loadImage(image: Image(url: presenter.data.lender.image.preview.path))
        lblFullName.text = presenter.data.lender.fullName
        lblLocation.text = presenter.data.lender.physicalAddress
        tvComment.text = "The Cold War was a state of geopolitical tension after World War II between powers in the Eastern Bloc (the Soviet Union and its satellite states) and powers in the Western Bloc (the United States, its NATO allies and others). Historians do not fully agree on the dates, but a common timeframe is the period between 1947, the year the Truman Doctrine, a U.S. foreign policy pledging to aid nations threatened by Soviet expansionism, was announced, and either 1989, when communism fell in Eastern Europe, or 1991, when the Soviet Union collapsed. The term cold is used because there was no large-scale fighting directly between the two sides, but they each supported major regional wars known as proxy wars."
        tvComment.textColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1)
        
        offerDetailSource = SttTableViewSource(tableView: offerDetailCollection, cellIdentifier: UIConstants.CellName.offerDetailCell, collection: presenter.collection)
        documentSource = SttCollectionSource(collectionView: documentCollection, cellIdentifier: UIConstants.CellName.documentLenderCell, collection: presenter.documentCollection)
        offerDetailCollection.dataSource = offerDetailSource
        documentCollection.dataSource = documentSource
        
        btnReject.setBorder(color: UIColor(named: "borderLight")!, size: 1)
        btnReject.layer.cornerRadius = 5
        btnApprove.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        offerDetailCollection.sizeToFit()
        cnstrHeight.constant = CGFloat(41 * presenter.collection.count + 15)
        tvComment.resize()
        cnstrTvHeight.constant = tvComment.frame.height
    }
}

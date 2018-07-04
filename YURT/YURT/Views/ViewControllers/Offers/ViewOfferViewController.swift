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
   
    private func deleteButtons() {
        self.btnApprove.removeFromSuperview()
        self.btnReject.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    func deleteButtons(status: Bool) {
        if status {
            self.createDecisionAlerDialog(title: "Offer has been aproved", message: "Do you want to return to list's offers?", handlerOk: {
                self.close(parametr: true)
            }, handlerFalse: { [weak self] in
                self?.deleteButtons()
            })
        }
        else {
            self.createDecisionAlerDialog(title: "Offer has been rejected", message: "Do you want to return to list's offers?", handlerOk: {
                self.close(parametr: false)
            }, handlerFalse: { [weak self] in
                self?.deleteButtons()
            })
        }
    }
    

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
    @IBOutlet weak var underline: UIView!
    
    @IBAction func aproveClick(_ sender: Any) {
        presenter.aprove.execute()
    }
    @IBAction func rejectClick(_ sender: Any) {
        presenter.rejectClick()
    }
    
    
    var offerDetailSource: SttTableViewSource<OfferDetailPresenter>!
    var documentSource: SttCollectionViewSource<DocumentLenderCellPresenter>!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        imgProfile.createCircle()
        imgProfile.loadImage(image: Image(url: presenter.data.lender.image.preview.path))
        lblFullName.text = presenter.data.lender.fullName
        lblLocation.text = presenter.data.lender.physicalAddress
        
        if let description = presenter.data.description {
            tvComment.text = description
        }
        else {
            tvComment.removeFromSuperview()
            underline.removeFromSuperview()
        }
        tvComment.textColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1)
        
        offerDetailSource = SttTableViewSource(tableView: offerDetailCollection, cellIdentifier: UIConstants.CellName.offerDetailCell, collection: presenter.collection)
        documentSource = SttCollectionViewSource(collectionView: documentCollection, cellIdentifiers: [SttIdentifiers(identifers: UIConstants.CellName.documentLenderCell, nibName: nil)], collection: presenter.documentCollection)
        offerDetailCollection.dataSource = offerDetailSource
        documentCollection.dataSource = documentSource
        
        btnReject.setBorder(color: UIColor(named: "borderLight")!, size: 1)
        btnReject.layer.cornerRadius = 5
        btnApprove.layer.cornerRadius = 5
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        offerDetailCollection.sizeToFit()
        cnstrHeight.constant = CGFloat(41 * presenter.collection.count + 15)
        tvComment?.resize()
        cnstrTvHeight?.constant = tvComment.frame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       presenter.aprove.useIndicator(button: btnApprove)
    }
}

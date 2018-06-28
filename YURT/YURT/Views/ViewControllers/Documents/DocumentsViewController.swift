//
//  DocumentsViewController.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class SttDefaultComponnents {
    class func createBarButtonLoader() -> (UIBarButtonItem, UIActivityIndicatorView) {
        let statusUpdatedIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        statusUpdatedIndicator.startAnimating()
        statusUpdatedIndicator.activityIndicatorViewStyle = .gray
        statusUpdatedIndicator.hidesWhenStopped = true
        let indicatorButton = UIBarButtonItem(customView: statusUpdatedIndicator)
        indicatorButton.isEnabled = false
        
        return (indicatorButton, statusUpdatedIndicator)
    }
}

class DocumentsViewController: SttViewController<DocumentsPresenter>, DocumentsDelegate {

    @IBOutlet weak var progressBackground: UIView!
    @IBOutlet weak var lblPercentWhite: UILabel!
    @IBOutlet weak var lblPercentBlack: UILabel!
    @IBOutlet weak var collectionDocuments: UICollectionView!
    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var cnstrLeftAnch: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblAllDocuments: UILabel!
    
    var statusUpdatedIndicator: UIActivityIndicatorView!
    
    @IBAction func send(_ sender: Any) {
        presenter.send.execute()
    }
    var collectionSource: DocumentEntitySource!
    
    override func viewDidLoad() {
        
        let loaderData = SttDefaultComponnents.createBarButtonLoader()
        self.navigationItem.setRightBarButton(loaderData.0, animated: true)
        statusUpdatedIndicator = loaderData.1
        
        super.viewDidLoad()

        progressBackground.createCircle(dominateWidth: false, clipToBounds: true)
        
        print ("---> \(presenter.documents)")
        collectionSource = DocumentEntitySource(collectionView: collectionDocuments, collection: presenter.documents)
        collectionDocuments.dataSource = collectionSource
                
        let width = widthScreen / 2 - 22
        let layout = collectionDocuments.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter.send.useIndicator(button: btnSend)

        btnSend.isUserInteractionEnabled = presenter.canSend
        btnSend.alpha = presenter.canSend ? 1.0 : 0.5
        btnSend.layer.cornerRadius = 5
        collectionDocuments.sizeToFit()
        cnstrHeight.constant = collectionDocuments.contentSize.height
        progressCahnged()
    }
    
    // MARK: implementation delegate

    func reloadItem(section: Int, row: Int) {
        collectionDocuments.reloadItems(at: [IndexPath(row: row, section: section)])
    }
    
    func progressCahnged() {
        let strNewValue = CountProgressConverter().convert(value: (presenter.currentUploaded, presenter.totalDocument))
        lblPercentBlack.text = strNewValue
        lblPercentWhite.text = strNewValue
        cnstrLeftAnch.constant = (progressBar.bounds.width - progressBar.bounds.width / CGFloat(presenter.totalDocument) * CGFloat(presenter.currentUploaded))
        btnSend.isUserInteractionEnabled = presenter.canSend
        btnSend.alpha = presenter.canSend ? 1.0 : 0.5
        lblAllDocuments.isHidden = presenter.canSend
        lblAllDocuments.text = presenter.currentUploaded == presenter.totalDocument ? "Your documents are successfully sent" : "All documents should be uploaded"
        UIView.animate(withDuration: 0.25, animations: { [weak self] in self?.view.layoutIfNeeded() })
    }
    
    func reloadData() {
        if collectionSource != nil {
            collectionSource.updateSource(collection: presenter.documents)
        }
    }
    
    func docUpdated() {
        statusUpdatedIndicator.stopAnimating()
    }
}

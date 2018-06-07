//
//  DocumentsViewController.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

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
    
    @IBAction func send(_ sender: Any) {
        presenter.send.execute()
    }
    var collectionSource: DocumentEntitySource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressBackground.createCircle(dominateWidth: false, clipToBounds: true)
        
        collectionSource = DocumentEntitySource(collectionView: collectionDocuments, collection: presenter.documents)
        
        collectionDocuments.dataSource = collectionSource
        
        presenter.send.useIndicator(button: btnSend)
        
        let width = widthScreen / 2 - 22
        let layout = collectionDocuments.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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
        btnSend.isEnabled = presenter.canSend
        lblAllDocuments.isHidden = presenter.canSend
    }
    
    func reloadData() {
        if let collectionS = collectionSource {
            collectionDocuments.reloadData()
//            collectionS._collection = presenter.documents
//            let indexes = [IndexPath(row: 0, section: 0),
//                           IndexPath(row: 1, section: 0),
//                           IndexPath(row: 2, section: 0),
//                           IndexPath(row: 3, section: 0),
//                           IndexPath(row: 4, section: 0),
//                           IndexPath(row: 0, section: 1),
//                           IndexPath(row: 1, section: 1),
//                           IndexPath(row: 2, section: 1),
//                           IndexPath(row: 3, section: 1)
//                        ]
//            collectionDocuments.reloadItems(at: indexes)
//            collectionDocuments.reloadSections([0, 1])
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
    @IBOutlet weak var cnstrProgresLeftAnchor: NSLayoutConstraint!
    @IBOutlet weak var lblPercentWhite: UILabel!
    @IBOutlet weak var lblPercentBlack: UILabel!
    @IBOutlet weak var collectionDocuments: UICollectionView!
    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    
    var collectionSource: DocumentEntitySource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressBackground.createCircle(dominateWidth: false, clipToBounds: true)
        
        collectionSource = DocumentEntitySource(collectionView: collectionDocuments, collection: presenter.documents)
        
        collectionDocuments.dataSource = collectionSource
        
        let width = widthScreen / 2 - 22
        let layout = collectionDocuments.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionDocuments.sizeToFit()
        cnstrHeight.constant = collectionDocuments.contentSize.height
    }
    
    // MARK: implementation delegate

    func reloadItem(section: Int, row: Int) {
        collectionDocuments.reloadItems(at: [IndexPath(row: row, section: section)])
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

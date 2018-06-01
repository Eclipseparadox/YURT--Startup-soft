//
//  DocumentEntitySource.swift
//  YURT
//
//  Created by Standret on 31.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class DocumentEntitySource: SttCollectionViewWithSectionSource<DocumentEntityPresenter, DocumentsEntityHeaderPresenter> {
    
    convenience init (collectionView: UICollectionView, collection: ([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter])!) {
        self.init(collectionView: collectionView, cellIdentifiers: [UIConstants.CellName.documentEntity, UIConstants.CellName.noDicumentEntity], sectionIdentifier: UIConstants.CellName.headerDocumentEntity, collection: collection)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let presenter = _collection.0[indexPath.section][indexPath.row]
        var nibName: String!
        switch presenter.type! {
        case .noDocument:
            nibName = UIConstants.CellName.noDicumentEntity
        case .document:
            nibName = UIConstants.CellName.documentEntity
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as! SttbCollectionViewCell
        cell.dataContext = _collection.0[indexPath.section][indexPath.row]
        cell.prepareBind()
        return cell
    }
}

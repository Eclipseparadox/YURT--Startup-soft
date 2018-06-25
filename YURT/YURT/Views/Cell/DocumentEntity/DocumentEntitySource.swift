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
    
    convenience init (collectionView: UICollectionView, collection: SttObservableCollection<(SttObservableCollection<DocumentEntityPresenter>, DocumentsEntityHeaderPresenter)>) {
        self.init(collectionView: collectionView,
                  cellIdentifiers: [SttIdentifiers(identifers: UIConstants.CellName.documentEntity, nibName: nil),
                                    SttIdentifiers(identifers: UIConstants.CellName.noDicumentEntity, nibName: nil)],
                  sectionIdentifier: [UIConstants.CellName.headerDocumentEntity],
            collection: collection)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let presenter = collection![indexPath.section].0[indexPath.row]
        var nibName: String!
        switch presenter.type ?? .document {
        case .noDocument:
            nibName = UIConstants.CellName.noDicumentEntity
        case .document:
            nibName = UIConstants.CellName.documentEntity
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as! SttCollectionViewCell<DocumentEntityPresenter>
        cell.presenter = collection![indexPath.section].0[indexPath.row]
        cell.prepareBind()
        return cell
    }
}

//
//  SttCollectionViewWithSectionSource.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class SttCollectionViewWithSectionSource<TCell: ViewInjector, TSection: ViewInjector>: NSObject, UICollectionViewDataSource {
    
    var _collectionView: UICollectionView
    var _cellIdentifier = [String]()
    var _sectionIdentifier: String
    
    var _collection: ([[TCell]], [TSection])! {
        didSet {
            //_collectionView.reloadData()
        }
    }
    
    required init (collectionView: UICollectionView, sectionIdentifier: String, collection: ([[TCell]], [TSection])!) {
        _collectionView = collectionView
        _collection = collection
        _sectionIdentifier = sectionIdentifier
    }
    
    convenience init(collectionView: UICollectionView, cellIdentifier: String, sectionIdentifier: String, collection: ([[TCell]], [TSection])!) {
        self.init(collectionView: collectionView, sectionIdentifier: sectionIdentifier, collection: collection)
        
        _cellIdentifier.append(cellIdentifier)
        
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    convenience init(collectionView: UICollectionView, cellIdentifiers: [String], sectionIdentifier: String, collection: ([[TCell]], [TSection])!) {
        self.init(collectionView: collectionView, sectionIdentifier: sectionIdentifier, collection: collection)

        _cellIdentifier = cellIdentifiers
        
        for item in cellIdentifiers {
            collectionView.register(UINib(nibName: item, bundle: nil), forCellWithReuseIdentifier: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collection.0[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _cellIdentifier.first!, for: indexPath) as! SttbCollectionViewCell
        cell.dataContext = _collection.0[indexPath.section][indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = _collection.0.count
        print(count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: _sectionIdentifier, for: indexPath) as! SttTCollectionReusableView<TSection>
        view.dataContext = _collection.1[indexPath.section]
        view.prepareBind()
        return view
    }
}

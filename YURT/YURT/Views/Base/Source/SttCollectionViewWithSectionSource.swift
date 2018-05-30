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
    var _cellIdentifier: String
    var _sectionIdentifier: String
    
    var _collection: ([[TCell]], [TSection])! {
        didSet {
            //_collectionView.reloadData()
        }
    }
    
    init(collectionView: UICollectionView, cellIdentifier: String, sectionIdentifier: String, collection: ([[TCell]], [TSection])!) {
        
        _collectionView = collectionView
        _cellIdentifier = cellIdentifier
        _sectionIdentifier = sectionIdentifier
        _collection = collection
        
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collection.0[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _cellIdentifier, for: indexPath) as! SttCollectionViewCell<TCell>
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

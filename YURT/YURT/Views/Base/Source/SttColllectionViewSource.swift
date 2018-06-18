//
//  SttColllectionViewWithSource.swift
//  YURT
//
//  Created by Standret on 18.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class SttCollectionSource<TCell: ViewInjector>: NSObject, UICollectionViewDataSource {
    
    var _collectionView: UICollectionView
    var _cellIdentifier = [String]()
    
    var _collection: [TCell] {
        didSet {
            //_collectionView.reloadData()
        }
    }
    
    required init (collectionView: UICollectionView, collection: [TCell]) {
        _collectionView = collectionView
        _collection = collection
    }
    
    convenience init(collectionView: UICollectionView, cellIdentifier: String, collection: [TCell]) {
        self.init(collectionView: collectionView, collection: collection)
        
        _cellIdentifier.append(cellIdentifier)
        
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    convenience init(collectionView: UICollectionView, cellIdentifiers: [String], collection: [TCell]) {
        self.init(collectionView: collectionView, collection: collection)
        
        _cellIdentifier = cellIdentifiers
        
        for item in cellIdentifiers {
            collectionView.register(UINib(nibName: item, bundle: nil), forCellWithReuseIdentifier: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _cellIdentifier.first!, for: indexPath) as! SttbCollectionViewCell
        cell.dataContext = _collection[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

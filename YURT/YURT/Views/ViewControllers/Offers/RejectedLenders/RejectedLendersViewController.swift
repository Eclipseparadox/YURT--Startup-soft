//
//  RejectedLendersViewController.swift
//  YURT
//
//  Created by Standret on 12.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import RxSwift

class RejectedLendersViewController: SttViewController<RejectedLendersPresenter>, RejectedLendersDelegate {   

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var source: SttTableViewSource<LenderPresenter>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblNoData.isHidden = presenter.lenders.count != 0
        source = SttTableViewSource(tableView: tableView, cellIdentifier: UIConstants.CellName.lenderCell, collection: presenter.lenders)
        tableView.dataSource = source
        tableView.reloadData()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 19))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 19))
        
        reloadLenders()
    }
    
    // MARK: -- Implement RejectedLendersDelegate
    
    var collectionDisaposable: Disposable?
    func reloadLenders() {
        source.updateSource(collection: presenter.lenders)//._collection = presenter.lenders
        collectionDisaposable?.dispose()
        collectionDisaposable = presenter.lenders.observableObject.subscribe(onNext: { [weak self] _ in
            self?.lblNoData.isHidden = self!.presenter.lenders.count != 0
        })
        lblNoData.isHidden = presenter.lenders.count != 0
    }
}

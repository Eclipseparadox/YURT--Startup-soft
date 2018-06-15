//
//  NewLendersViewController.swift
//  YURT
//
//  Created by Standret on 12.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class NewLendersViewController: SttViewController<NewLendersPresenter>, NewLendersDelegate, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var source: SttTableViewSource<LenderPresenter>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblNoData.isHidden = presenter.lenders.count != 0
        source = SttTableViewSource(tableView: tableView, cellIdentifier: UIConstants.CellName.lenderCell, collection: presenter.lenders)
        tableView.dataSource = source
        tableView.delegate = self
        tableView.reloadData()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 19))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 19))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    // MARK: -- Implement Delegate NewLenders

    func reloadLenders() {
        lblNoData.isHidden = presenter.lenders.count != 0
        source._collection = presenter.lenders
    }
}

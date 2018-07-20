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

class SttLoaderView: UIView {
    
    var isLoading: Bool = false {
        didSet {
            loaderView.isHidden = !isLoading
        }
    }
    
    weak var delegate: UIViewController! {
        didSet {
            injectComponnent()
        }
    }
    
    private var loaderView: UIView!
    
    private func injectComponnent() {
        loaderView = UIView()
        loaderView.backgroundColor = UIColor.white
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        delegate.view.addSubview(loaderView)
        delegate.view.safeTopAnchor.constraint(equalTo: loaderView.topAnchor).isActive = true
        delegate.view.safeLeftAnchor.constraint(equalTo: loaderView.leftAnchor).isActive = true
        delegate.view.safeRightAnchor.constraint(equalTo: loaderView.rightAnchor).isActive = true
        delegate.view.safeBottomAnchor.constraint(equalTo: loaderView.bottomAnchor).isActive = true
        
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.addSubview(activityIndicatorView)
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.startAnimating()
        loaderView.addConstraints([
            NSLayoutConstraint(item: loaderView, attribute: .centerX, relatedBy: .equal, toItem: activityIndicatorView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loaderView, attribute: .centerY, relatedBy: .equal, toItem: activityIndicatorView, attribute: .centerY, multiplier: 1, constant: 0)
            ])
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
    @IBOutlet weak var cnstrBottom: NSLayoutConstraint!
    
    var statusUpdatedIndicator: UIActivityIndicatorView!
    var generalLoaderView = SttLoaderView()
    
    @IBAction func send(_ sender: Any) {
        presenter.send.execute()
    }
    var collectionSource: DocumentEntitySource!
    
    override func viewDidLoad() {
        
//        let loaderData = SttDefaultComponnents.createBarButtonLoader()
//        self.navigationItem.setRightBarButton(loaderData.0, animated: true)
//        statusUpdatedIndicator = loaderData.1
        
        super.viewDidLoad()

        progressBackground.createCircle(dominateWidth: false, clipToBounds: true)
        
        print ("---> \(presenter.documents)")
        collectionSource = DocumentEntitySource(collectionView: collectionDocuments, collection: presenter.documents)
        collectionDocuments.dataSource = collectionSource
                
        let width = widthScreen / 2 - 22
        let layout = collectionDocuments.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        generalLoaderView.delegate = self
    }
    
    private var firstStart = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if firstStart {
            presenter.send.useIndicator(button: btnSend)
            firstStart = false
        }

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
        
        if presenter.currentUploaded == presenter.totalDocument && !presenter.canSend {
            cnstrBottom.constant = -52
        }
        else {
            cnstrBottom.constant = 42
        }
    }
    
    func reloadData() {
        if collectionSource != nil {
            collectionSource.updateSource(collection: presenter.documents)
        }
    }
    
    func docUpdated() {
        generalLoaderView.isLoading = false
        //statusUpdatedIndicator.stopAnimating()
    }
}

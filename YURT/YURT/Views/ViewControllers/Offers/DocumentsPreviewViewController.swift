//
//  DocumentsPreviewViewController.swift
//  YURT
//
//  Created by Standret on 26.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class DocumentsPreviewViewController: SttViewController<DocumentPreviewPresenter>, DocumentPreviewDelegate {
    
    @IBOutlet weak var imgPreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style = .lightContent
    }
    
    func insertImage(image: UIImage) {
        imgPreview.image = image
    }
}

//
//  PreviewPhotoViewController.swift
//  YURT
//
//  Created by Standret on 29.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class PreviewPhotoViewController: UIViewController {
    
    var image: UIImage!
    weak var delegate: SttTakePhotoDelegate!

    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate.close(isUsePhoto: false)
    }
    @IBAction func usePhotoClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate.close(isUsePhoto: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgPhoto.image = image
    }
}

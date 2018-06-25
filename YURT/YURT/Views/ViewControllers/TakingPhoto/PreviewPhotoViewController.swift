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
        dismiss(animated: false, completion: nil)
        delegate.close(isUsePhoto: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print ("open view")
        imgPhoto.image = image.fixOrientation()
        
        _ = SttGlobalObserver.observableStatusApplication.subscribe(onNext: { [weak self] (status) in
            if status == .EnterBackgound {
                self?.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func rotateImage(image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy!
    }
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}

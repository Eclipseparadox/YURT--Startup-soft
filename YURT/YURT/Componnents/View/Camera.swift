//
//  Camera.swift
//  YURT
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class Camera: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let picker = UIImagePickerController()
    private let callBack: (UIImage) -> Void
    private let parent: UIViewController!
    
    init (parent: UIViewController, handler: @escaping (UIImage) -> Void) {
        self.callBack = handler
        self.parent = parent
        super.init()
        picker.delegate = self
    }
    
    func takePhoto() {
        picker.sourceType = .camera
        parent.present(picker, animated: true, completion: nil)
    }
    func selectPhoto() {
        picker.sourceType = .photoLibrary
        parent.present(picker, animated: true, completion: nil)
    }
    
    func showPopuForDecision() {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionController.addAction(UIAlertAction(title: "From galery", style: .default, handler: { (x) in
            self.selectPhoto()
        }))
        actionController.addAction(UIAlertAction(title: "From camera", style: .default, handler: { (x) in
            self.takePhoto()
        }))
        actionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        parent.present(actionController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let _image = image?.fixOrientation() {
            callBack(_image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

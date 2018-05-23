//
//  DialogAlert.swift
//  YURT
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func createAlerDialog(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            self.resignFirstResponder()
        }))
        
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = self.view
            popover.permittedArrowDirections = .up
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

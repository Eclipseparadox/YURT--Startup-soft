//
//  UIImageView.swift
//  YURT
//
//  Created by Standret on 06.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(image: Image) {
        
        if let _url = image.url {
            print(_url)
            self.sd_setImage(with: URL(string: _url), placeholderImage: UIImage(named: "placeholder"), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                
                self.image = image
                if error != nil {
                    print(error)
                    self.image = UIImage(named: "placeholder")
                }
            })
        }
        else if let _data = image.data {
            self.image = UIImage(data: _data)
        }
        else if let _image = image.image {
            self.image = _image
        }
    }
}

//
//  ShowPhotoViewController.swift
//  YURT
//
//  Created by Standret on 04.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ShowPhotoViewController: SttViewController<ShowPhotoPresenter>, ShowPhotoDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cnstrBottomImage: NSLayoutConstraint!
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnDelete.createCircle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData(type: DocumentType, image: Image) {
        imgView.image = image.image?.fixOrientation()
        lblTitle.text = type.rawValue
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

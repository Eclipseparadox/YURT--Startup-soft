//
//  ProfileViewController.swift
//  YURT
//
//  Created by Standret on 05.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import KeychainSwift
import RealmSwift

class ProfileViewController: SttViewController<ProfilePresenter>, ProfileDelegate {
    
    @IBAction func exit(_ sender: Any) {
        KeychainSwift().delete(Constants.tokenKey)
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        navigate(storyboardName: "Login", type: .modality, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  FeedVC.swift
//  devslopes-social
//
//  Created by Luis Guillermo on 2/7/17.
//  Copyright © 2017 Luis Guillermo. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutTapped(_ sender: Any) {
        
        if KeychainWrapper.standard.removeObject(forKey: KEY_UI) {
            try! Auth.auth().signOut()
            performSegue(withIdentifier: "goToSignIn", sender: nil)
        }
        
    }
}

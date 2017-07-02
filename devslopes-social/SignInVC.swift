//
//  ViewController.swift
//  devslopes-social
//
//  Created by Luis Guillermo on 1/7/17.
//  Copyright © 2017 Luis Guillermo. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
//        loginButton.center = view.center
//        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("ERROR: \(error)")
            case .cancelled:
                print("User cancelled login.")
            case .success:
                print("Logged in with FACEBOOK!")
                let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
                
                Auth.auth().signIn(with: credential) { (user, error) in
                    if error != nil {
                        print("FIREBASE Loggin Fail: \(error)")
                    } else {
                        print("Logged in with FIREBASE!")
                    }
                }
            }
        }
    }
}

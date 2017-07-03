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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UI) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                        print("FIREBASE Loggin Fail: \(String(describing: error))")
                    } else {
                        print("Logged in with FIREBASE!")
                        if let user = user {
                            let userData = ["provider": credential.provider]
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("Email user authentication with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate with Firebase using email: \(String(describing: error))")
                        } else {
                            print("Successfully authenticated with Firebase using email")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        if KeychainWrapper.standard.set(id, forKey: KEY_UI) {
            print("Data saved to keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        } else {
            print("Data culdn't be saved to keychain")
        }
    }
}

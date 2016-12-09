//
//  ViewController.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-06.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

import Firebase


class SignInVC: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var emailField: CustomUITextField!
    @IBOutlet weak var pwdField: CustomUITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Firebase signin with Facebook stuff
    @IBAction func facebookBtnTapped(_ sender: Any) {
         let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result,error) in
            if error != nil {
                print("KBP: Unable to authentication with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                print("KBP: User cancelled Facebook authentication")
                
            } else {
                print("KBP: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
            }
        }
    }

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("KBP: Unable to authenticate with FB into Firebase - \(error)")
                
            } else {
                print("KBP: Successfully used FB to authenicate to Firebase")
                
            }
        }) // end if FIRAuth line....
    }  // end of func firebaseAuth ()
    
    
    // Firebase signin with username/email stuff
    @IBAction func signinTapped(_ sender: Any) {
        
        // ensure we have text in the entry fields
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    // this means we signed in!  Greeat!
                    print("KBP: User authenticated with email/pwd to Firebase.")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            // something really wrong
                            print("KBP: Unable to authenticate with Firebase using email.")
                        } else {
                            // account created!
                            print("KBP: User created adn authenticated with email/pwd to Firebase.")
                        }
                    }) // end if FIRAuth create user line....
                    
                }
                
            }) // end if FIRAuth signin line....
        }
    }
}

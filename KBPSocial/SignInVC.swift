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

import SwiftKeychainWrapper


class SignInVC: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var emailField: CustomUITextField!
    @IBOutlet weak var pwdField: CustomUITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // check if the UID has been previously stored in device keychain
        // we don't do anything with it, just need to know if it exists
        // if it does, we're 'signed in' so perform seque to next storyboard scene
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("KBP: UID extracted from keychain in SignInVC! whoot!")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        } else {
            // nothing has been previously saved, so continue as normal
            // and call login stuff
            print("KBP: no previous UID found - go to signin")
        }
        
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
                
                // store 'uid' to local device keychain for subsequent logins
               if let user = user {
                self.completeSignIn(id: user.uid)
                }
                
                
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
                    
                    // save id to keychain
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            // something really wrong
                            print("KBP: Unable to authenticate with Firebase using email.")
                        } else {
                            // account created!
                            print("KBP: User created and authenticated with email/pwd to Firebase.")
                            
                            // save id to keychain
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    }) // end if FIRAuth create user line....
                    
                }
                
            }) // end if FIRAuth signin line....
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("KBP: UID saved to keychain: \(keychainResult)")
        
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}

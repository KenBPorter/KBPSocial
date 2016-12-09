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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
    
}

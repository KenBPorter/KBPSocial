//
//  FeedVC.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-09.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase


class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signOutPressed(_ sender: UIButton) {
        // remove UID from keychain
        
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("KBP: uid removed from keychain \(keychainResult)")
        
        // signout of firebase
        try! FIRAuth.auth()?.signOut()
            
        
        // dismiss this view controller - go back to previous VC
        dismiss(animated: true, completion: nil)
    }
}






































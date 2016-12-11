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


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    // UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // initialize the Firebase 'listener(s)' to react to db changes
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = [] // THIS IS THE NEW LINE
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")

                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        // got a post, store it into the array
                        self.posts.append(post)
                    }
                    
                } // end of for
            }
            self.tableView.reloadData()
        })
        
        

        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Protocol methods/functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rowsinsection: \(posts.count)")
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("KBP: \(post.caption)")
        
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    
    // @IBActions
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






































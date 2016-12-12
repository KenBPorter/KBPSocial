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



class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CustomCircleView!
    
    var posts = [Post]()
    
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    // UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // initialize image picker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            
           
        } else {
            return PostCell()
        }
        
    }
    
    // ImagePicker protocol methods/functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // images and video can be returned in the array of returned stuff.  
        // Make sure we are getting an image
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAdd.image = image
        } else {
            print("KBP: wasn't a valid image picked")
        }
        
        // once image picked, make picker go away!
        imagePicker.dismiss(animated: true, completion: nil)
        
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
    
    
    @IBAction func addImagePressed(_ sender: Any) {
        // show image picker controller
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
}






































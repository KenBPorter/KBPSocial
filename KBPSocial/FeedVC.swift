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
    @IBOutlet weak var captionField: CustomUITextField!    
    
    var posts = [Post]()
    
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    
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
        
        
        // initialize the Firebase 'observer' to react to db.posts changes
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            // within an ({enclosure}) so we need the 'self.' syntax a lot
            
            self.posts = []
            
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
            imageSelected = true
            
        } else {
            print("KBP: wasn't a valid image picked")
        }
        
        // once image picked, make picker go away!
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    // @IBActions
    @IBAction func signOutPressed(_ sender: UIButton) {
        // remove UID from keychain
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
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
    
    
    @IBAction func postBtnPressed(_ sender: Any) {
        
        // do a bit of checking before we allow a post
        guard let caption = captionField.text, caption != "" else {
            print("KBP: no caption provided - can't create post")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
            print("KBP: no image provided - can't create post")
            return
        }
        
        //time to updload stuff
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            // create a 'random' UUID string to associate with the image
            let imgUID = UUID().uuidString
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUID).put(imgData,metadata: metadata) { (metadata, error) in
                
                if error != nil {
                 print("KBP: Unable to upload img to firebase storage \(error)")
                    
                } else {
                    print("KBP: Successfully uploaded img to firebase storage 👍")
                    
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadURL {
                        self.postToFirebase(imgURL: url)
                    }
                    
                    
                }
                
                
            }
            
        }
        
    }
    
    
    
    // some functions of our own
    
    func postToFirebase(imgURL: String) {
        
        let post: Dictionary<String, AnyObject> = [
        "caption": captionField.text as AnyObject,
        "imageURL": imgURL as AnyObject,
        "likes": 0 as AnyObject
        ]
        
        // create new obj in FirDB - let FirDB create a UUID for the user
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        // now clean up the UI 
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        // reload tableView in UI with new post
        tableView.reloadData()
        
    }
    
}









//
//  PostCell.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-09.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    // @IBOutlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    @IBOutlet weak var likeImg: UIImageView!

    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // setup a gesture recognizer for each Like button in the table cell
        // can't do this thru storyboard interface, only programatically since it's
        // on a scrolling table view (i think thats the reason)
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }

    // the img: UIImage? = nil bit gives this paramater a default value
    // allowing for that paramer to be skipped in the call
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        if img != nil {
            self.postImg.image = img
        } else {
            // no image passed in from program's cache so download it
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                // within an ({enclosure}) so we need the 'self.' syntax a lot
                
                if error != nil {
                    print("KBP: PostCell.swift-unable to download image from Firebase Storage")
                } else {
                    //we've downloaded the image so cache it
                    print("KBP: PostCell.swift-Image downloaded from Firebase Storage👍")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
        
        // setup a 'single event' observer for a change to the likes count in user
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // within an ({enclosure}) so we need the 'self.' syntax a lot
            
            if let _ = snapshot.value as? NSNull {
                //no like exists
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                // previous like exists
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
    }
 
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        // setup a 'single event' observer for a change to the likes count in user
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // within an ({enclosure}) so we need the 'self.' syntax a lot
            
            if let _ = snapshot.value as? NSNull {
                //no like exists so modify likes count on post
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                
                // now add to list of likes within the user part of db
                self.likesRef.setValue(true)
                
            } else {
                // previous like exists
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
            
                // now remove this like from the users's list of likes
                self.likesRef.removeValue()
                
            }
        })
        
    }
    
    
}























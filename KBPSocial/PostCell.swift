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
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // the img: UIImage? = nil bit gives this paramater a default value
    // allowing for that paramer to be skipped in the call
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            // no image passed in from program's cache so download it
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
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
        
    }
    
}

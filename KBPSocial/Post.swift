//
//  Post.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-11.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageURL: String, likes: Int) {
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>)  {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageURL = postData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        // set internal reference for the current post
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            // increment like count
            _likes = _likes + 1
            
        } else {
            // subtract from like count
            _likes = _likes - 1
            
        }

        // now update the likes counter on the current post in the FIR DB
        _postRef.child("likes").setValue(_likes)
        
    }
    
}

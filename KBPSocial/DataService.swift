//
//  DataService.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-10.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()


class DataService {
    
    // a single instance of this class that is globally available
    // (aka a SINGLETON) because of this next line
    static let ds = DataService()
    
    // Firebase DB references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // Firebase storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
//    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("")
    
    
    // Firebase Database References
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        // get uuid from keychain
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        
        // now create user reference constand
        let user = REF_USERS.child(uid!)
        
        return user
    }
    
    // Firebase Storage References
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        // create a new user if it doesn't already exist
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
}

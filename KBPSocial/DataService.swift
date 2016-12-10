//
//  DataService.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-10.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()


class DataService {
    
    // a single instance of this class that is globally available
    // (aka a SINGLETON) because of this next line
    static let ds = DataService()
    
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        // create a new user if it doesn't already exist
        REF_USERS.child(uid).updateChildValues(userData)
        
        
        
    }
}

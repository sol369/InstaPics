//
//  Database.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/16/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Database: NSObject {
    
    //Singleton
    static var shared: Database {
        struct Static {
            static let instance = Database()
        }
        return Static.instance
    }
    
    private let root = FIRDatabase.database().reference()
    //all the paths for the database
    var users: FIRDatabaseReference {
        return root.child("users")
    }
    
    var currentUser: FIRDatabaseReference {
        return users.child(Auth.shared.currentUserId)
    }
    
    var posts: FIRDatabaseReference {
        return root.child("posts")
    }


    //USERS
    //Save user info
    func saveUser(uid: String, value: [String: String], completion: @escaping (Error?) -> Void) {
        let values = ["/users/\(uid)": value]
        root.updateChildValues(values) { (error, _) in
            completion(error)
        }
    }
    //Update the current user
    func updateUser(newValue: [String: Any]) {
        currentUser.updateChildValues(newValue)
    }
    //Get the current users name
    func getFullName(completion: @escaping (String?) -> Void) {
        
        currentUser.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            if let userDict = snapshot.value as? Dictionary<String, AnyObject> {
                completion(userDict["name"] as? String)
            }
        }
    }
    
    
    
}

//
//  Storage.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/16/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class Storage: NSObject {
    
    static var shared: Storage {
        struct Static {
            static let instance = Storage()
        }
        return Static.instance
    }
    
    // MARK: - References
    private var root = FIRStorage.storage().reference()
    //All the paths for the storage
    private var users: FIRStorageReference {
        return root.child("users")
    }
    private var currentUser: FIRStorageReference {
        return users.child(Auth.shared.currentUserId)
    }
    private var posts: FIRStorageReference {
        return root.child("posts").child(Auth.shared.currentUserId)
    }

    //Upload the current users profile image to storage
    func uploadProfileImage(_ data: Data, name: String, completion: @escaping (_ downloadUrl: String?, _ error: Error?) -> Void) {
        
        let uploadMetadata = FIRStorageMetadata()
        
        currentUser.child(name).put(data, metadata: uploadMetadata) { metadata, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }

            let downloadUrl = metadata?.downloadURL()?.absoluteString
            completion(downloadUrl, nil)
        }
    }
    //Upload the users post image to storage
    func uploadPostImage(_ data: Data, name: String, metadata: FIRStorageMetadata, completion: @escaping (_ downloadUrl: String?, _ error: Error?) -> Void) {
        
        
        posts.child(name).put(data, metadata: metadata) { metadata, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            let downloadUrl = metadata?.downloadURL()?.absoluteString
            completion(downloadUrl, nil)
        }
    }
    
    
}

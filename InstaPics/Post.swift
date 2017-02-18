//
//  Post.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/16/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//

import Firebase
import FirebaseDatabase

class Post: NSObject {
    
    let postOwner: String?
    let postOwnerId: String?
    let postImageUrl: String?
    let postId: String?
    
    init(id: String, dictionary: [String: Any]) {
        self.postId = id
        self.postOwner = dictionary["postOwner"] as? String
        self.postOwnerId = dictionary["postOwnerId"] as? String
        self.postImageUrl = dictionary["postImageUrl"] as? String
    }
    
}

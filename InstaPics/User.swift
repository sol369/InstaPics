//
//  User.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/17/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//

import UIKit

class User: NSObject {
    
    //MARK: Properties
    let id: String!
    let name: String!
    let email: String!
    let profilePicUrl: String!
    var postCount: Int!
    
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.name = dictionary["name"] as! String
        self.email = dictionary["email"] as! String
        self.profilePicUrl = dictionary["profilePicUrl"] as! String
        self.postCount = dictionary["postCount"] as! Int
    }

}

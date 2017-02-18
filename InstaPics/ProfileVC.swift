//
//  ProfileVC.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/17/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//

import UIKit
import SwiftLoader
import Firebase

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var postCount: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    var helper = Helper()
    var userId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = Auth.shared.currentUserId
        loadProfilePic(userId!)
        loadUserPosts(userId!)

    }
    
    func loadProfilePic(_ uid: String) {
        SwiftLoader.show(title: "Loading your profile...", animated: true)
        //Get the current user object and set the information
        Database.shared.currentUser.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            if let userDict = snapshot.value as? [String: Any] {
                let key = snapshot.key
                let user = User(id: key, dictionary: userDict)
                self.fullName.text = user.name
                self.postCount.text = "\(user.postCount!)"
                
                //load profile image
                self.profileImageView.kf.setImage(with: URL(string: user.profilePicUrl))
                SwiftLoader.hide()
            }
        }
    }
    
    func loadUserPosts(_ uid: String) {
        //first remove all posts so we dont get duplicates
        posts.removeAll()
        SwiftLoader.show(title: "Loading your profile...", animated: true)
        //Get the current users posts
        Database.shared.currentUser.child("posts").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            
            Database.shared.posts.child(snapshot.key).observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
                
                if let postDict = snap.value as? [String: Any] {
                    let post = Post(id: snap.key, dictionary: postDict)
                    print(post)
                    self.posts.insert(post, at: 0)
                    self.collectionView.reloadData()
                }
                
                SwiftLoader.hide()
                self.collectionView.reloadData()
            })
        }
    }
    
    //COLLECTION DELEGATES
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
        let post = posts[indexPath.row]
        item.postImageView.kf.setImage(with: URL(string: post.postImageUrl!))
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selected
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }


}

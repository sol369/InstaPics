//
//  FeedVC.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/16/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SwiftLoader

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var helper = Helper()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPosts()
    }
    
    //Function to get all the posts
    func getPosts() {
        SwiftLoader.show(title: "Loading posts...", animated: true)
        Database.shared.posts.observe(.value) { (snapshot: FIRDataSnapshot) in
            
            if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts = []
                for snap in snaps {
                    if let postDict = snap.value as? [String: Any] {
                        
                        let key = snap.key
                        let post = Post(id: key, dictionary: postDict)
                        //add the post to posts array
                        self.posts.append(post)
                    }
                }
            }
            SwiftLoader.hide()
            self.tableView.reloadData()
        }
    }
    
    //TABLE VIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Setup the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        
        let post = self.posts[indexPath.row]
        
        cell.nameLabel.text = post.postOwner
        cell.postImageView.kf.setImage(with: URL(string: post.postImageUrl!))
        
        return cell
    }
    
}

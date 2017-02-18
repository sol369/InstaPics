//
//  PostVC.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/16/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//

import UIKit
import Sharaku
import Firebase
import SwiftLoader

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var helper = Helper()
    var postId: String?
    var didSelectPicture = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //random id for the new post
        postId = NSUUID().uuidString

    }
    
    @IBAction func addPicturePressed(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func postPressed(_ sender: AnyObject) {
        
        if didSelectPicture {
            SwiftLoader.show(title: "Posting..", animated: true)
            let img = postImageView.image
            
            let data = UIImageJPEGRepresentation(img!, 0.5)!
            let pathName = "\(Date.timeIntervalSinceReferenceDate).jpg"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            
            Storage.shared.uploadPostImage(data, name: pathName, metadata: metadata) { (picUrl, error) in
                
                guard error == nil else {
                    self.helper.errorAlert(title: "Error", msg: error!.localizedDescription)
                    SwiftLoader.hide()
                    return
                }
                
                Database.shared.getFullName(completion: { (fullName) in
                    let postOwner = fullName
                    let postOwnerId = Auth.shared.currentUserId
                    let postImageUrl = picUrl
                    
                    let postData = ["postId": self.postId!,
                                    "postOwner": postOwner!,
                                    "postOwnerId": postOwnerId,
                                    "postImageUrl": postImageUrl!] as [String: String]
                    
                    //Upload the post object to the database
                    Database.shared.posts.child(self.postId!).updateChildValues(postData, withCompletionBlock: { (err, _) in
                        
                        guard err == nil else {
                            self.helper.errorAlert(title: "Error", msg: err!.localizedDescription)
                            SwiftLoader.hide()
                            return
                        }
                        //Update the current users posts for the postId to true
                        Database.shared.currentUser.child("posts").updateChildValues([self.postId!: true])
                        //Update the user post count
                        self.updatePostCount()
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                    SwiftLoader.hide()
                })
            }
            
        } else {
            self.helper.errorAlert(title: "No picture", msg: "Please select a picture before posting.")
        }
        

    }
    
    func updatePostCount() {
        Database.shared.currentUser.observeSingleEvent(of: .value, with: { (snapUser: FIRDataSnapshot) in
            
            if let userDict = snapUser.value as? [String: Any] {
                let user = User(id: snapUser.key, dictionary: userDict)
                let newPostCount = user.postCount + 1
                Database.shared.updateUser(newValue: ["postCount": newPostCount])
            }
        })
    }
    
    @IBAction func backPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        //set the selected image and change didSelectPicture to true
        postImageView.image = image
        didSelectPicture = true
        
        //dismiss the camera view controller and open the filters view controller
        dismiss(animated: true, completion: {
            self.openFilter()
        })
        
    }
    func openFilter() {
        let filterThisImage = postImageView.image
        let vc = SHViewController(image: filterThisImage!)
        vc.delegate = self
        self.present(vc, animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true) { 
            self.dismiss(animated: true, completion: nil)
        }
    }

}

//Delegate
extension PostVC: SHViewControllerDelegate {
    
    func shViewControllerImageDidFilter(_ image: UIImage) {
        postImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func shViewControllerDidCancel() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}

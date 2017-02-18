//
//  SignupVC.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/16/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//

import UIKit
import SwiftLoader
import Firebase

class SignupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var isDefaultImage = true
    var helper = Helper()
    var nameText: String!
    var emailText: String!
    var passwordText: String!
    var confirmPasswordText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changePicPressed(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }

    @IBAction func signupPressed(_ sender: AnyObject) {
        nameText = nameTextField.text?.trim()
        emailText = emailTextField.text?.trim()
        passwordText = passwordTextField.text?.trim()
        confirmPasswordText = confirmPasswordField.text?.trim()
        
        //Check if text fields are empty
        guard !isTextFieldsEmpty() else {
            helper.errorAlert(title: "Empty", msg: "Make sure you fill everything out.")
            return
        }
        
        //Check if passwords match
        guard passwordText == confirmPasswordText else {
            helper.errorAlert(title: "Don't Match", msg: "Your passwords don't match.")
            return
        }
        
        //Register the new user
        Auth.shared.registerNewUser(email: emailText, password: passwordText) { (error) in
            SwiftLoader.show(title: "Signing you up...", animated: true)
            
            guard error == nil else {
                self.helper.errorAlert(title: "Error", msg: error!.localizedDescription)
                SwiftLoader.hide()
                return
            }
            //Save the profile image
            self.saveProfileImage(completionHandler: { (picUrl, err) in
                
                guard err == nil else {
                    self.helper.errorAlert(title: "Error", msg: error!.localizedDescription)
                    SwiftLoader.hide()
                    return
                }
                //User data to upload to firebase
                let userData = ["name": self.nameText,
                                "email": self.emailText,
                                "profilePicUrl": picUrl! as String,
                                "userId": Auth.shared.currentUserId] as [String: String]
                
                //Now save the user to the database after registration
                Database.shared.saveUser(uid: Auth.shared.currentUserId, value: userData, completion: { (err3) in
                    
                    guard err3 == nil else {
                        self.helper.errorAlert(title: "Error", msg: err3!.localizedDescription)
                        SwiftLoader.hide()
                        return
                    }
                    //Set the users post count to 0
                    Database.shared.updateUser(newValue: ["postCount": 0])
                    SwiftLoader.hide()
                    //Segue to the feed view controller
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedVC")
                    self.present(vc!, animated: true, completion: nil)
                    
                })
            })
        }
    }
    
    
    func isTextFieldsEmpty()-> Bool {
        if nameText.isEmpty || emailText.isEmpty || passwordText.isEmpty || confirmPasswordText.isEmpty {
            return true
        }
        return false
    }
    
    func saveProfileImage(completionHandler: @escaping (_ picUrl: String?, _ err: Error?) -> Void) {
        let data = UIImageJPEGRepresentation(self.profileImageView.image!, 0.6)
        let imageName = UUID().uuidString + ".jpg"
        
        Storage.shared.uploadProfileImage(data!, name: imageName) { (downloadUrl, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            completionHandler(downloadUrl, nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}

//
//  ViewController.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/16/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//

import UIKit
import SwiftLoader

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var helper = Helper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginPressed(_ sender: AnyObject) {
        //Check if the text fields are empty
        if (emailTextField.text?.characters.count)! > 1 && (passwordTextField.text?.characters.count)! > 1 {
            
            SwiftLoader.show(title: "Logging in...", animated: true)
            //Login the user
            Auth.shared.loginUser(email: emailTextField.text!, password: (passwordTextField.text?.trim())!, completion: { (error) in
                if let error = error {
                    self.helper.errorAlert(title: "Error", msg: error.localizedDescription)
                } else {
                    //Segue to the feed view controller
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedVC")
                    self.present(vc!, animated: true, completion: nil)
                }
                SwiftLoader.hide()
            })
            
        } else {
            self.helper.errorAlert(title: "Empty", msg: "Make sure you fill everything out.")
        }
        
    }


}


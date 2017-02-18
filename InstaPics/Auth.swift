//
//  Auth.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/16/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//


import Foundation
import FirebaseAuth

class Auth {
    //singleton
    static var shared: Auth {
        struct Static {
            static let instance = Auth()
        }
        return Static.instance
    }
    
    private let auth = FIRAuth.auth()
    private let isLoggedInKey = "isLoggedIn"
    
    var currentUserId: String {
        get {
            return (auth?.currentUser?.uid) ?? ""
        }
    }
    
    var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    //Register the new user
    func registerNewUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        
        auth?.createUser(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                completion(error)
                return
            }
            UserDefaults.standard.set(true, forKey: self.isLoggedInKey)
            completion(nil)
        }
    }
    //Login the user
    func loginUser(email: String, password: String, completion: @escaping (Error?) -> Void) {

        auth?.signIn(withEmail: email, password: password, completion: { (_, error) in
            guard error == nil else {
                completion(error)
                return
            }
            UserDefaults.standard.set(true, forKey: self.isLoggedInKey)
            completion(nil)
        })
        
    }
    //Logout the current user
    func logout() {
        if ((try? auth?.signOut()) != nil) {
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
    }
}

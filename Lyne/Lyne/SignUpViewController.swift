//
//  SignUpViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 7/14/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import OneSignal
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        

        // Do any additional setup after loading the view.
        
        //OneSignal.idsAvailable({(_ userId, _ pushToken) in
            //print("UserId:\(userId)")
            //playerID = userId!
            //newPth.child("player_id").setValue(userId)
            //newPth.child("user_firstName").setValue("Brian")
            
            //if pushToken != nil {
                //print("pushToken:\(pushToken)")
            //}
        //})
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            
            User.currentUser.setUpUser()
            self.performSegue(withIdentifier: "mainview", sender: nil)
            
        } else {
            print("user is NOT signed in")
            // ...
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error == nil {
                let ref : DatabaseReference! = Database.database().reference()
                ref.child("users").child(user!.uid).updateChildValues(["name": self.firstNameField.text!])
                self.performSegue(withIdentifier: "mainview", sender: self)
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    

}

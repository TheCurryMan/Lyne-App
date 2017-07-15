//
//  LoginViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 7/14/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import OneSignal
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userNameTF.layer.cornerRadius = 5;
        passwordTF.layer.cornerRadius = 5;
        signInButton.layer.cornerRadius = 5;
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        
        
        //        try! Auth.auth().signOut()
        
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    @IBAction func tappedScreen(_ sender: Any) {
        print("tapped")
        self.userNameTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
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
    
    
    @IBAction func pressedSignIn(_ sender: Any) {
        print("pressed")
        Auth.auth().signIn(withEmail: self.userNameTF.text!, password: self.passwordTF.text!) { (user, error) in
            if user != nil {
                print("sign in successful")
                
                User.currentUser.setUpUser()
                
                
//                OneSignal.idsAvailable({(_ userId, _ pushToken) in
//                    print("UserId:\(userId)")
//                    playerID = userId!
//                    if pushToken != nil {
//                        print("pushToken:\(pushToken)")
//                    }
//                })
                
                self.performSegue(withIdentifier: "mainview", sender: nil)
            }
            else{
                print("sign in failed")
                
            }
        }
        
    }
    
    @IBAction func signup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

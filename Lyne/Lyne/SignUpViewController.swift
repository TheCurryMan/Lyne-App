//
//  SignUpViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 7/14/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import OneSignal

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

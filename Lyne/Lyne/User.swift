//
//  User.swift
//  Lyne
//
//  Created by Avinash Jain on 7/12/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import Foundation
import Firebase

class User {
    var name : String?
    var UID : String?
    var playerID : String?
    var lyneJoinedID : String?
    var lyneJoinedPos : String?
    var lyneCreated : Lyne?
    
    static var currentUser = User()
    let ref : DatabaseReference = Database.database().reference()
    private init() {
    }
    
    func addToLyne(id: String){
        self.lyneJoinedID = id
        ref.child("lynes").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            var users = value?["users"] as? [String]
            let num = value?["num"] as! Int
            let pos = value?["pos"] as! Int
            self.lyneJoinedPos = String(num + pos)
            users!.append(User.currentUser.UID!)
            self.ref.child("lynes").child(id).updateChildValues(["users": users!, "num":(num+1)])
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func setUID() {
        UID = Auth.auth().currentUser?.uid
    }
    
    func setUpUser() {
        UID = Auth.auth().currentUser?.uid
        
        
        ref.child("users").child(UID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.name = value?["name"] as? String
            self.playerID = value?["playerID"] as? String
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    func createLyne(lyne: Lyne) {
        let ref : DatabaseReference! = Database.database().reference()
        
        let data = ["lat":lyne.loc!.latitude, "lon":lyne.loc!.longitude, "name":lyne.name!, "num":lyne.num!, "pos":lyne.pos!, "users":lyne.users!] as [String : Any]
        
        ref.child("lynes").child("\(lyne.id!)").setValue(data)
        
        self.lyneCreated = lyne
    }
    
}

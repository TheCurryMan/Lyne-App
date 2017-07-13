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
    var lyneJoined : Lyne?
    var lyneCreated : Lyne?
    
    static var currentUser = User()
    
    private init() {
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    
    
    func createLyne(lyne: Lyne) {
        let ref : DatabaseReference! = Database.database().reference()
        
        let data = ["lat":lyne.loc!.latitude, "long":lyne.loc!.longitude, "name":lyne.name!, "num":0, "pos":1] as [String : Any]
        
        ref.child("lynes").child("\(lyne.id!)").setValue(data)
        
        self.lyneCreated = lyne
    }
    
}

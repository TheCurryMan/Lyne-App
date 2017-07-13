//
//  Lyne.swift
//  Lyne
//
//  Created by Avinash Jain on 7/11/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import Foundation
import CoreLocation

struct Lyne {
    var name : String?
    var num : Int?
    var pos : Int?
    var loc : CLLocationCoordinate2D?
    var id : String?
    var users : [String]?
    
    mutating func updateValues(dict: [String: AnyObject]) {
    
        self.num = dict["num"] as? Int
        self.pos = dict["pos"] as? Int
        self.users = dict["users"] as? [String]
    }
    
}

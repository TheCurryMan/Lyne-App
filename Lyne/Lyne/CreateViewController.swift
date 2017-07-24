//
//  CreateViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 7/11/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation


class CreateViewController: UIViewController {

    var ref: DatabaseReference!
    
    @IBOutlet weak var lyneName: UITextField!
    @IBOutlet weak var lyneID: UITextField!
    @IBOutlet weak var lyneLocation: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        backgroundView.layer.cornerRadius = 10
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func createLyne(_ sender: Any) {
        
        
        
        let address = lyneLocation.text!
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            
            let lyne = Lyne(name: self.lyneName.text!, num: 0, pos: 1, loc: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), id: self.lyneID.text!, users: ["start"])
            
                User.currentUser.createLyne(lyne: lyne)
            
                self.performSegue(withIdentifier: "create", sender: self)
            }
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

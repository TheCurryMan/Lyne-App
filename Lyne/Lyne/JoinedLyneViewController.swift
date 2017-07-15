//
//  JoinedLyneViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 7/15/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Firebase

class JoinedLyneViewController: UIViewController {

    @IBOutlet weak var currentPositionLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    let ref : DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref.child("lynes").child(User.currentUser.lyneJoinedID!).observe(.value, with: {(snapshot) in
            let data = snapshot.value as! [String: AnyObject]
            self.positionLabel.text = String(data["pos"] as! Int)
            self.numLabel.text = String(data["num"] as! Int)
            self.etaLabel.text = String(data["num"] as! Int)
            self.currentPositionLabel.text = User.currentUser.lyneJoinedPos!
        
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func leaveLyne(_ sender: Any) {
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

//
//  ManageLyneViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 7/12/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ManageLyneViewController: UIViewController {
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lyneName: UILabel!
    @IBOutlet weak var lynePosition: UILabel!
    @IBOutlet weak var lyneCurrentUserName: UILabel!
    @IBOutlet weak var lyneNumberOfPeople: UILabel!
    
    @IBOutlet weak var checkmarkButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        updateView()
        getData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func updateView() {
        self.lyneName.text = User.currentUser.lyneCreated!.name!
        self.lynePosition.text = "#\(String(describing: User.currentUser.lyneCreated!.pos!))"
        self.lyneNumberOfPeople.text = "\(String(describing: User.currentUser.lyneCreated!.num!)) People in Lyne"
    }
    
    func getData() {
        let ref : DatabaseReference! = Database.database().reference()
        
        _ = ref.child("lynes").child(User.currentUser.lyneCreated!.id!).observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            User.currentUser.lyneCreated?.updateValues(dict: postDict)
            self.updateView()
        })
    }
    
    
    @IBAction func personShowedUp(_ sender: Any) {
        
        print(User.currentUser.lyneCreated!.num!)
        checkmarkButton.setImage(UIImage(named: "greencheck.png"), for: UIControlState.normal)
    }

    @IBAction func nextPerson(_ sender: Any) {
        
        
    }

    @IBAction func addPerson(_ sender: Any) {
        
        
    }
  
    
}

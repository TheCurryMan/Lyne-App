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
    
    var ref : DatabaseReference!
    
    var cu = User.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        getData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func updateView() {
        
        
        
        if (cu.lyneCreated?.num)! == 0 {
            self.checkmarkButton.isHidden = true
            self.lyneCurrentUserName.isHidden = true
        } else {
        
            
        self.checkmarkButton.isHidden = false
        self.lyneCurrentUserName.isHidden = false
            
        self.lyneName.text = cu.lyneCreated!.name!
        self.lynePosition.text = "#\(String(describing: cu.lyneCreated!.pos!))"
        self.lyneNumberOfPeople.text = "\(String(describing: cu.lyneCreated!.num!)) People in Lyne"
        self.lyneCurrentUserName.text = cu.lyneCreated!.users![1]
            
        }
    }
    
    func getData() {
        ref = Database.database().reference()
        
        _ = ref.child("lynes").child(cu.lyneCreated!.id!).observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.cu.lyneCreated?.updateValues(dict: postDict)
            self.updateView()
        })
    }
    
    
    @IBAction func personShowedUp(_ sender: Any) {
        
        print(cu.lyneCreated!.num!)
        checkmarkButton.setImage(UIImage(named: "greencheck.png"), for: UIControlState.normal)
    }

    @IBAction func nextPerson(_ sender: Any) {
        
        cu.lyneCreated?.users?.remove(at: 1)
        cu.lyneCreated?.num! -= 1
        cu.lyneCreated?.pos! += 1
        
        ref.child("lynes").child(cu.lyneCreated!.id!).updateChildValues(["pos":(cu.lyneCreated?.pos)!, "num": (cu.lyneCreated?.num)!, "users":(cu.lyneCreated?.users)!])
        
        updateView()
    }

    @IBAction func addPerson(_ sender: Any) {
        
        
    }
  
    
}

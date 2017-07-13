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
    
    var checkPressed = false
    var timerCounter = 20
    weak var timer : Timer?
    
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
        
            if !checkPressed && timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                timerLabel.textColor = UIColor.green
            }
            
            self.checkmarkButton.isHidden = false
            self.lyneCurrentUserName.isHidden = false
                
            self.lyneName.text = cu.lyneCreated!.name!
            self.lyneCurrentUserName.text = cu.lyneCreated!.users![1]
        }
        self.lynePosition.text = "#\(String(describing: cu.lyneCreated!.pos!))"
        if (cu.lyneCreated?.num)! == 1 {
            self.lyneNumberOfPeople.text = "\(String(describing: cu.lyneCreated!.num!)) Person in Lyne"
        } else {
            self.lyneNumberOfPeople.text = "\(String(describing: cu.lyneCreated!.num!)) People in Lyne"
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
        
        checkPressed = true
        checkmarkButton.setImage(UIImage(named: "greencheck.png"), for: UIControlState.normal)
        timer?.invalidate()
        timerCounter = 20
        timerLabel.text = "00:\(timerCounter)"
        timerLabel.textColor = UIColor.lightGray
    }

    @IBAction func nextPerson(_ sender: Any) {
        
        cu.lyneCreated?.users?.remove(at: 1)
        cu.lyneCreated?.num! -= 1
        cu.lyneCreated?.pos! += 1
        
        self.checkPressed = false
        checkmarkButton.setImage(UIImage(named: "checkmark.png"), for: UIControlState.normal)
        
        
        ref.child("lynes").child(cu.lyneCreated!.id!).updateChildValues(["pos":(cu.lyneCreated?.pos)!, "num": (cu.lyneCreated?.num)!, "users":(cu.lyneCreated?.users)!])
        
        updateView()
    }

    @IBAction func addPerson(_ sender: Any) {
        
        
    }
    
    func updateTimer() {
        timerCounter -= 1
        
        timerLabel.text = "00:\(timerCounter)"
    }
  
    
}

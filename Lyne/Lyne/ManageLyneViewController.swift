//
//  ManageLyneViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 7/12/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SCLAlertView
import Alamofire

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
    
    var playerid = ""
    var name = ""
    
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
            
            if ((cu.lyneCreated!.users?[1])!.characters.count) >= 25 {
                getUserData(uid: (cu.lyneCreated!.users?[1])!)
            } else {
                self.lyneCurrentUserName.text = "No Phone - " + (cu.lyneCreated!.users?[1])!
            }
            
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
    
    func getUserData(uid: String) {
        _ = ref.child("users").child(uid).observe(DataEventType.value, with: {(snapshot) in
            let value = snapshot.value as? [String: AnyObject]
            if (self.playerid != value!["playerID"] as! String) {
                self.playerid = value!["playerID"] as! String
                self.lyneCurrentUserName.text = value!["name"] as! String
                self.sendNotificationToFirstUser()
            }
        })
    }
    
    
    func sendNotificationToFirstUser(){
        print("making new request")
        let url = "https://damp-atoll-26489.herokuapp.com"
        Alamofire.request(url + "?userID=" + self.playerid + "&lyneID=" + (self.cu.lyneCreated?.id!)!).responseJSON { response in
            if let data = response.data, let dataString = String(data: data, encoding: .utf8) {
                print("Result: " + dataString)
            }
        }
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
        
        timer?.invalidate()
        timerCounter = 20
        timerLabel.text = "00:\(timerCounter)"
        
        self.playerid = ""
        
        self.checkPressed = false
        checkmarkButton.setImage(UIImage(named: "checkmark.png"), for: UIControlState.normal)
        
        
        ref.child("lynes").child(cu.lyneCreated!.id!).updateChildValues(["pos":(cu.lyneCreated?.pos)!, "num": (cu.lyneCreated?.num)!, "users":(cu.lyneCreated?.users)!])
        
        updateView()
    }
    
    @IBAction func addPerson(_ sender: Any) {
        timer?.invalidate()
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Avenir Next", size: 30)!,
            kTextFont: UIFont(name: "Avenir Next", size: 16)!,
            kButtonFont: UIFont(name: "Avenir Next", size: 16)!,
            showCloseButton: false,
            showCircularIcon: false
            
        )
        let alert = SCLAlertView(appearance: appearance)
        
        let txt = alert.addTextField("Enter Name")
        alert.addButton("Done") {
            let key = txt.text!
            self.cu.lyneCreated?.num! += 1
            self.cu.lyneCreated?.users?.append(key)
            self.ref.child("lynes").child(self.cu.lyneCreated!.id!).updateChildValues(["num": (self.cu.lyneCreated?.num)!, "users":(self.cu.lyneCreated?.users)!])
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            //self.ref.child("users").child("\(key)").setValue(["name": txt.text!])
        }
        alert.addButton("Cancel") {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
        
        alert.showInfo("#\((cu.lyneCreated?.num)! + (cu.lyneCreated?.pos)!)", subTitle: "Add Person to Lyne")
    }
    
    func updateTimer() {
        timerCounter -= 1
        if timerCounter < 10 {
            timerLabel.text = "00:0\(timerCounter)"
        } else if timerCounter < 1 {
            nextPerson(self)
        } else {
            timerLabel.text = "00:\(timerCounter)"
        }
    }
    
    
}

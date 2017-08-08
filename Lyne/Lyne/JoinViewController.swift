//
//  JoinViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 7/9/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import MapKit
import OneSignal
import FirebaseDatabase
import SCLAlertView

class JoinTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lyneNameLabel: UILabel!
    @IBOutlet weak var lynePeopleLabel: UILabel!
    @IBOutlet weak var lynePositionLabel: UILabel!
    @IBOutlet weak var lyneDistanceLabel: UILabel!
    
    @IBOutlet weak var lyneID: UILabel!
}

class JoinViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, OSSubscriptionObserver {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noLyneLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var ref: DatabaseReference!
    var lynes = [Lyne]()
    
    var userLocation = CLLocation()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            locateMe()
            getFirebaseData()
        } else {
            giveWarningAboutAcceptances()
        }

        
        tableView.register( UINib(nibName: "LyneTableViewCell", bundle:nil), forCellReuseIdentifier: "join")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFirebaseData(){
        ref = Database.database().reference()
        let postRef = ref.child("lynes")
        _ = postRef.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            for lyne in postDict {
                let pair = lyne.value as! [String:AnyObject]
                let coords = CLLocationCoordinate2DMake(pair["lat"] as! CLLocationDegrees, pair["lon"] as! CLLocationDegrees)
                
                if self.getDistanceFromCurrentLocation(otherLoc: coords) < 100 {
                    let newLyne = Lyne(name: pair["name"] as? String, num: pair["num"] as? Int, pos: pair["pos"] as? Int, loc: coords, id: lyne.key, users: pair["users"] as! [String])
                    self.lynes.append(newLyne)
                }
               
            }
            
            self.tableView.reloadData()
            self.addAnnotations()
        })
    }
    
    func giveWarningAboutAcceptances() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Avenir Next", size: 30)!,
            kTextFont: UIFont(name: "Avenir Next", size: 16)!,
            kButtonFont: UIFont(name: "Avenir Next", size: 16)!,
            showCloseButton: false,
            showCircularIcon: false
            
        )
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("Okay") {
            self.getFirebaseData()
            self.promptPushNotification()
            
        }
        
        alert.showInfo("Hi!", subTitle: "Before you get started, we're going to need your location to find nearby lynes and send you push notifications when you're at the front!")
    }
 
    @IBAction func locateMe() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
  
        locationManager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.003,0.003 )
            let region = MKCoordinateRegion(center: coordinations, span: span)
            mapView.setRegion(region, animated: true)
        
    }
    
    func addAnnotations(){
        for lyne in lynes{
            
            let CLLCoordType = CLLocationCoordinate2D(latitude: lyne.loc!.latitude,
                                                      longitude: lyne.loc!.longitude)
            let anno = MKPointAnnotation()
            anno.coordinate = CLLCoordType
            
            mapView.addAnnotation(anno)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "anno")
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "anno")
    
        annotationView!.image = UIImage(named: "annotation.png")
        
        return annotationView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lynes.count == 0 {
            self.noLyneLabel.isHidden = false
        } else {
            self.noLyneLabel.isHidden = true
        }
        return lynes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : JoinTableViewCell = tableView.dequeueReusableCell(withIdentifier: "join") as! JoinTableViewCell
        
        let currentLyne = lynes[indexPath.row]
        cell.lyneDistanceLabel.text = String(format: "%.2f", getDistanceFromCurrentLocation(otherLoc: currentLyne.loc!)) + "m"
        cell.lyneNameLabel.text = currentLyne.name
        cell.lynePeopleLabel.text = "There are \(currentLyne.num!) people in the lyne"
        cell.lynePositionLabel.text = "#\(currentLyne.pos!)"
        cell.lyneID.text = "\(currentLyne.id!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! JoinTableViewCell
        ref.child("users").child(User.currentUser.UID!).updateChildValues(["lyneJoined":cell.lyneID.text])
        User.currentUser.addToLyne(id: cell.lyneID.text!)
        performSegue(withIdentifier: "joined", sender: self)
    }
    
    func getDistanceFromCurrentLocation(otherLoc: CLLocationCoordinate2D) -> CLLocationDistance
    {
        let lyneLoc = CLLocation.init(latitude: otherLoc.latitude, longitude: otherLoc.longitude)
        return userLocation.distance(from: lyneLoc)
        
    }
    
    func promptPushNotification() {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            OneSignal.add(self as OSSubscriptionObserver)
        })
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerID = stateChanges.to.userId {
            print("Current playerId \(playerID)")
            ref.child("users").child(User.currentUser.UID!).updateChildValues(["playerID":playerID])
        }
        self.locateMe()
    }
    
    
}

//
//  JoinViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 7/9/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class JoinTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lyneNameLabel: UILabel!
    @IBOutlet weak var lynePeopleLabel: UILabel!
    @IBOutlet weak var lynePositionLabel: UILabel!
    @IBOutlet weak var lyneDistanceLabel: UILabel!
    
}

class JoinViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()
    var ref: DatabaseReference!
    var lynes = [Lyne]()
    
    var userLocation = CLLocation()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locateMe()
        tableView.register( UINib(nibName: "LyneTableViewCell", bundle:nil), forCellReuseIdentifier: "join")
        getFirebaseData()
        
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
                let coords = CLLocationCoordinate2DMake(pair["lat"] as! CLLocationDegrees, pair["long"] as! CLLocationDegrees)
                let newLyne = Lyne(name: pair["name"] as? String, num: pair["num"] as? Int, pos: pair["pos"] as? Int, loc: coords, id: lyne.key, users: pair["users"] as! [String])
                self.lynes.append(newLyne)
            }
            
            self.tableView.reloadData()
            self.addAnnotations()
        })
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
        
        return cell
    }
    
    func getDistanceFromCurrentLocation(otherLoc: CLLocationCoordinate2D) -> CLLocationDistance
    {
        let lyneLoc = CLLocation.init(latitude: otherLoc.latitude, longitude: otherLoc.longitude)
        return userLocation.distance(from: lyneLoc)
        
    }
    
}

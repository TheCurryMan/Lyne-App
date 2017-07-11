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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locateMe()
        let locations = [CLLocation(latitude: 37.309489, longitude: -122.003984), CLLocation(latitude: 37.309536, longitude: -122.004575)]
        addAnnotations(coords: locations)
        
        tableView.register( UINib(nibName: "LyneTableViewCell", bundle:nil), forCellReuseIdentifier: "join")
        
        ref = Database.database().reference()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func locateMe() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        locationManager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.003,0.003 )
            let region = MKCoordinateRegion(center: coordinations, span: span)
            mapView.setRegion(region, animated: true)
        
    }
    
    func addAnnotations(coords: [CLLocation]){
        for coord in coords{
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                      longitude: coord.coordinate.longitude)
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
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : JoinTableViewCell = tableView.dequeueReusableCell(withIdentifier: "join") as! JoinTableViewCell
        
        cell.lyneDistanceLabel.text = "0.2 mi"
        cell.lyneNameLabel.text = "Lynbrook Yearbook Lyne"
        cell.lynePeopleLabel.text = "There are 19 people in the lyne"
        cell.lynePositionLabel.text = "#35"
        
        return cell
    }
    
}

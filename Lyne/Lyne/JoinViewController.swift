//
//  JoinViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 7/9/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import MapKit

class JoinViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locateMe()
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
      
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
        
        if mapView.annotations.count < 1 {
        
            let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
            let span = MKCoordinateSpanMake(0.005,0.005)
            let region = MKCoordinateRegion(center: coordinations, span: span)
            mapView.setRegion(region, animated: true)
        }
        
       
        addRadiusCircle(location: userLocation)
        
    }
    
    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: 100 as CLLocationDistance)
        self.mapView.add(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if self.mapView.overlays.count > 0 {
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.reloadInputViews()
        }
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blue
        
            circle.lineWidth = 1
            return circle
         
    }
}

//
//  InfoStadionViewController.swift
//  Eticket Persib
//
//  Created by Apit on 8/15/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import MapKit

class InfoStadionViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapkitView: MKMapView!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        mapkitView.delegate = self
        mapkitView.showsScale = true
        mapkitView.showsPointsOfInterest = true
        mapkitView.showsUserLocation = true
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
//        let sourceCoordinate = locationManager.location?.coordinate
//        let destinationCoordinate = CLLocationCoordinate2D(latitude: -6.996592, longitude: 107.52971619999994)
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: -6.996592, longitude: 107.52971619999994)
        annotation.coordinate = centerCoordinate
        annotation.title = "Stadion si Jalak Harupat"
        let latDelta: CLLocationDegrees = 0.02
        let lonDelta: CLLocationDegrees = 0.02
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-6.996592, 107.52971619999994)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapkitView.setRegion(region, animated: true)
        mapkitView.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLoction: CLLocation = locations[0]
//        let latitude = userLoction.coordinate.latitude
//        let longitude = userLoction.coordinate.longitude
//        let latDelta: CLLocationDegrees = 0.05
//        let lonDelta: CLLocationDegrees = 0.05
//        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
//        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
//        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
//        self.mapkitView.setRegion(region, animated: true)
//        self.mapkitView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

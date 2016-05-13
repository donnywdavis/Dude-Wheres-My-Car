//
//  ViewController.swift
//  DudeWheresMyCar
//
//  Created by Donny Davis on 5/13/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //
    // MARK: Properties
    //
    
    weak var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let mapRegionRadius: CLLocationDistance = 500
//    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    
    //
    // MARK: View Life Cycle
    //

    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationAuthorization()
        
        let storedLocation = retrieveLocation()
        
        if let storedLocation = storedLocation {
            mapView.addAnnotation(storedLocation)
            centerMapOnLocation(storedLocation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //
    // MARK: Button Actions
    //

    @IBAction func getCurrentLocation(sender: UIBarButtonItem) {
        locationManager.startUpdatingLocation()
        guard let mapViewUserLocation = mapView.userLocation.location else {
            locationManager.stopUpdatingLocation()
            return
        }
        
        let currentLocation: Location = Location(coordinate: CLLocationCoordinate2DMake(mapViewUserLocation.coordinate.latitude, mapViewUserLocation.coordinate.longitude), title: "Current Location", subtitle: "")
        mapView.addAnnotation(currentLocation)
        centerMapOnLocation(currentLocation)
        saveLocation(currentLocation)
        locationManager.stopUpdatingLocation()
    }
    
    
    //
    // MARK: Map Helper Functions
    //
    
    func checkLocationAuthorization() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: Location) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, mapRegionRadius * 2.0, mapRegionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    //
    // MARK: User Defaults
    //
    
    func saveLocation(location: Location) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(location)
        appDelegate?.defaults.setObject(data, forKey: "storedLocation")
    }
    
    func retrieveLocation() -> Location? {
        if let storedLocationData = appDelegate?.defaults.objectForKey("storedLocation") as? NSData {
            let storedLocation = NSKeyedUnarchiver.unarchiveObjectWithData(storedLocationData)
            guard let coordinate = storedLocation?.coordinate, let title = storedLocation?.title, let subtitle = storedLocation?.subtitle else {
                return nil
            }
            
            return Location(coordinate: coordinate, title: title, subtitle: subtitle)
        }
        
        return nil
    }

}


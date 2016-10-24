//
//  BusinessesMapViewController.swift
//  Yelp
//
//  Created by Ernest on 10/21/16.
//  Copyright © 2016 Purpleblue.com. All rights reserved.
//

import UIKit
import MapKit

class BusinessesMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mapView.delegate = self
        
        // We saved it in InitNavigationController
        let defaults = UserDefaults.standard
        let userLocation = defaults.object(forKey: "yelp_user_location") as? [String: Double] ?? [String: Double]()
        
        let centerLocation = CLLocation(latitude: userLocation["lat"]!, longitude: userLocation["lng"]!)
        goToLocation(location: centerLocation)
        
        //InitNavigationController.locMgr
        
        populateMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data
    
    func populateMap() {
        for business in businesses {
            //print(business.name!)
            //print(business.address!)
            
            // Add annotations
            let location2 = CLLocationCoordinate2D(latitude: business.coordinateLat!, longitude: business.coordinateLng!)
            addAnnotationAtCoordinate(coordinate: location2, title: business.name!, subtitle: business.address!)
        }
    }
    
    // MARK: - Map
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        
        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        annotationView!.image = UIImage(named: "yelp-icon")
        
        return annotationView
    }
    
}

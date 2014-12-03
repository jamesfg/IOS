//
//  MapViewController.swift
//  SocialJournal
//
//  Created by Matt Phillips on 11/20/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var mapView: MKMapView!
    var currentEntry = PFObject(className: "Entry")
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        var location = CLLocation(latitude: self.currentEntry["location"].latitude, longitude: self.currentEntry["location"].longitude)
        
        var span = MKCoordinateSpanMake(0.5, 0.5)
        var region = MKCoordinateRegion(center: location.coordinate, span: span)
            
        self.mapView.setRegion(region, animated: true)
            
        var annotation = MKPointAnnotation()
        annotation.setCoordinate(location.coordinate)
        annotation.title = "city/locality"
        annotation.subtitle = "region"
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                annotation.title = pm.locality
                annotation.subtitle = pm.country
                //println("Placemark: " + pm.locality + "Annotation: " + annotation.title)
                //println("Placemark: " + pm.country + "Annotation: " + annotation.subtitle)
            }
        })
        self.mapView.addAnnotation(annotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is MKPointAnnotation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView.annotation = annotation
        }
        
        return anView
    }
    
    
}
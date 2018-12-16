//
//  MapViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/15/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 250
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let newAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            newAnnotation.animatesWhenAdded = true
            newAnnotation.titleVisibility = .adaptive
            newAnnotation.subtitleVisibility = .adaptive
            return newAnnotation
        }
        else {return nil}
        
        
        /*
        guard annotation is MKPointAnnotation else {return nil}
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if(annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        return annotationView
    */
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self 

        let initialLocation = CLLocation(latitude: 32.775216, longitude: -117.071124)
        centerMapOnLocation(location: initialLocation)
        
        getAnnotationData()
    }
    
    //MARK: Helper Functions
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getAnnotationData() {
        let data = Database.database().reference().child("groups")
        data.observeSingleEvent(of: .value) { snapshot in
            for groups in snapshot.children {
                let snap = groups as! DataSnapshot
                let groupID = snap.key
                let groupChildren = data.child(groupID)
                groupChildren.observeSingleEvent(of: .value) { childSnap in
                    
                    var latitude = 0.0
                    var longitude = 0.0
                    var course = ""
                    var location = ""
                    var groupName = ""
                    var details = ""
                    
                    for groupData in childSnap.children {
                        let csnap = groupData as! DataSnapshot
                        let dataMember = csnap.key
                        let memberInfo = csnap.value
                        if(dataMember == "latitude") {
                            latitude = memberInfo as! Double
                        }
                        else if (dataMember == "longitude") {
                            longitude = memberInfo as! Double
                        }
                        else if (dataMember == "course"){
                            course = memberInfo as! String
                        }
                        else if (dataMember == "location") {
                            location = memberInfo as! String
                        }
                        else if (dataMember == "groupName") {
                            groupName = memberInfo as! String
                        }
                        else {
                            details = memberInfo as! String
                        }
                    }
                    let annotationEntry = Group(groupName: groupName, groupID: groupID, location: location, locationLat: latitude, locationLong: longitude, locationDetails: details, course: course)
                    self.dropPin(entry: annotationEntry)
                }
            }
        }
    }
    
    
    func dropPin(entry: Group) {
        //let groupLocation = MKPointAnnotation()
        
        //groupLocation.title = entry.groupName
        //groupLocation.coordinate = CLLocationCoordinate2D(latitude: entry.locationLat, longitude: entry.locationLong)
        
        let locationCoordinates = CLLocationCoordinate2D(latitude: entry.locationLat, longitude: entry.locationLong)
        let subtitle = "\(entry.location) \nDetails: \(entry.locationDetails) \n\(entry.course)"
        let annotationInfo = Annotation(coordinate: locationCoordinates, title: entry.groupName, subtitle: subtitle)
        
        mapView.addAnnotation(annotationInfo)
    }
}

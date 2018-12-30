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

/* Map View Controller
 *
 * Map Page that is centered at campus center.  Dispalys study group pins when they are created.
 * User can click pins and see detailed study group information
 */
class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Properties
    
    let regionRadius: CLLocationDistance = 350
    
    //MARK: Initial Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set delegate
        self.mapView.delegate = self 
        //Set the map center at campus center
        let initialLocation = CLLocation(latitude: 32.775216, longitude: -117.071124)
        centerMapOnLocation(location: initialLocation)
        //Get the already created annotations to dispaly on map
        getAnnotationData()
    }
    
    //MARK: Map Methods
    
    /* Creates the Annotaions for the pin drops */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let newAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            newAnnotation.animatesWhenAdded = true
            newAnnotation.titleVisibility = .adaptive
            newAnnotation.subtitleVisibility = .adaptive
            return newAnnotation
        }
        else {return nil}
    }
    
    //MARK: Private Methods
    
    /* Centers the map on specified location */
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /* Gets the study groups information to create annotations for each group */
    private func getAnnotationData() {
        //Reference the database
        let data = Database.database().reference().child("groups")
        data.observeSingleEvent(of: .value) { snapshot in
            //Loop through all the create study groups
            for groups in snapshot.children {
                let snap = groups as! DataSnapshot
                let groupID = snap.key
                let groupChildren = data.child(groupID)
                groupChildren.observeSingleEvent(of: .value) { childSnap in
                    //Local variables for each groups information
                    var latitude = 0.0
                    var longitude = 0.0
                    var course = ""
                    var location = ""
                    var groupName = ""
                    var details = ""
                    //Loop through each study groups detailed data
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
                    //Create an annotation entry for the group details
                    let annotationEntry = Group(groupName: groupName, groupID: groupID, location: location, locationLat: latitude, locationLong: longitude, locationDetails: details, course: course)
                    //Drop the pin on the map
                    self.dropPin(entry: annotationEntry)
                }
            }
        }
    }
    
    /* Drops a pin at the specific coordinates for the study group*/
    private func dropPin(entry: Group) {
        let locationCoordinates = CLLocationCoordinate2D(latitude: entry.locationLat, longitude: entry.locationLong)
        let subtitle = "\(entry.location) \nDetails: \(entry.locationDetails) \n\(entry.course)"
        let annotationInfo = Annotation(coordinate: locationCoordinates, title: entry.groupName, subtitle: subtitle)
        mapView.addAnnotation(annotationInfo)
    }
}

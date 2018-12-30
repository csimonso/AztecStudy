//
//  GroupDetailsViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/16/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import MapKit

/* Group Details View Controller
 *
 * Displays the details of the selected study group
 */
class GroupDetailsViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Outlets

    @IBOutlet var groupLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationView: UIView!
    @IBOutlet var mapBox: UIView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var detailsView: UIView!
    @IBOutlet var joinButton: UIButton!
    
    //MARK: Properties
    
    var group: Group!
    let regionRadius: CLLocationDistance = 250
    
    //MARK: Inital Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set initial properties
        groupLabel.text = group.groupName
        locationLabel.text = group.location
        detailsLabel.text = group.locationDetails
        joinButton.layer.cornerRadius = 10
        joinButton.clipsToBounds = true
        locationView.layer.shadowColor = UIColor.black.cgColor
        locationView.layer.shadowOpacity = 1
        locationView.layer.shadowOffset = CGSize.zero
        locationView.layer.shadowRadius = 10
        detailsView.layer.shadowColor = UIColor.black.cgColor
        detailsView.layer.shadowOpacity = 1
        detailsView.layer.shadowOffset = CGSize.zero
        detailsView.layer.shadowRadius = 10
        mapBox.layer.shadowColor = UIColor.black.cgColor
        mapBox.layer.shadowOpacity = 1
        mapBox.layer.shadowOffset = CGSize.zero
        mapBox.layer.shadowRadius = 10
        // Set delegate
        self.mapView.delegate = self
        //Set the map center to group location
        let initialLocation = CLLocation(latitude: group.locationLat, longitude: group.locationLong)
        centerMapOnLocation(location: initialLocation)
        //Drop a pin on the map showing where the study group is
        dropPin()
    }
    
    //MARK: Action
    
    /* Join group displays an alert notifying user that he has joined */
    @IBAction func joingGroup(_ sender: Any) {
        let alertController = UIAlertController(title: "Welcome To \(group.groupName)", message: "Head On Over To \(group.location)", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
            self.performSegue(withIdentifier: "DetailsToWelcome", sender: self)
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: Map Methods
    
    /* Creates an annotation makring the location of the group */
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
    
    /* Centers the map on the specific location*/
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /* Drops a pin on the map */
    private func dropPin() {
        let locationCoordinates = CLLocationCoordinate2D(latitude: group.locationLat, longitude: group.locationLong)
        let annotationInfo = Annotation(coordinate: locationCoordinates, title: group.location, subtitle: group.locationDetails)
        mapView.addAnnotation(annotationInfo)
    }
}

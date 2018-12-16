//
//  Annotation.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/15/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import Foundation
import MapKit


class Annotation: NSObject, MKAnnotation {
    
    //MARK: Properties
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    
    //MARK: Initialization
    init(coordinate:CLLocationCoordinate2D, title: String, subtitle: String) {
        //Initialize properties
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
    }
}


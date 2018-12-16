//
//  Group.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/15/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import Foundation

class Group {
    //MARK: Properties
    var groupName: String
    var groupID: String
    var location: String
    var locationLat: Double
    var locationLong: Double
    var locationDetails: String
    var course: String
    
    //MARK: Initialization
    init(groupName: String, groupID: String, location: String, locationLat: Double, locationLong: Double, locationDetails: String, course: String) {
        //Initialize properties
        self.groupName = groupName
        self.groupID = groupID
        self.location = location
        self.locationLat = locationLat
        self.locationLong = locationLong
        self.locationDetails = locationDetails
        self.course = course 
    }
}

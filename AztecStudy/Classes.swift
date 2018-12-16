//
//  Classes.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/14/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit

class Classes {
    //MARK: Properties
    var time: String
    var days: String
    var className: String
    var classID: String
    
    //MARK: Initialization
    init(className: String, classID: String, days: String, time: String) {
        //Initialize properties
        self.className = className
        self.classID = classID
        self.time = time
        self.days = days
    }
}

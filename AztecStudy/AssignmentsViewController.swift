//
//  AssignmentsViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/16/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit

/* Assignments View Controller
 *
 * Main Tab Bar Controller for the Assignments
 */
class AssignmentsViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set properties
        self.title = "Assignments"
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 25)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 25)!], for: .selected)
    }
}

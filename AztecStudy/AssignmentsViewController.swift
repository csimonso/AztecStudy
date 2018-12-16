//
//  AssignmentsViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/16/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit

class AssignmentsViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Assignments"
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 25)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 25)!], for: .selected)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

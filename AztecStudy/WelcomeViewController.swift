//
//  WelcomeViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 10/6/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

/* Welcome View Controller
 *
 * Main screen when Logged in.  Allows user to click any of the 6 navigation buttons
 */
class WelcomeViewController: UIViewController {
    
    //MARK: Action
    
    /* Unwind Segue */
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
    }
    
    /* Segue to Schedule Page */
    @IBAction func schedule(_ sender: Any) {
        performSegue(withIdentifier: "WelcomeToSchedule", sender: self)
    }
    
    /* Logs user out, resets user defaults */
    @IBAction func logout(_ sender: Any) {
        do {
            //Signs user out of Firebase
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print("Error logging out: \(error)")
        }
        //Reset user defaults so user must log in next session
        resetDefaults()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = main
    }
    
    //MARK: Initial Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Private Methods
    
    /* Resets the user defaults */
    private func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

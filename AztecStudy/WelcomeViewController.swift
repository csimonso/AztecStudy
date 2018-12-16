//
//  WelcomeViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 10/6/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    //MARK: Action
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
    }
    
    @IBAction func schedule(_ sender: Any) {
        performSegue(withIdentifier: "WelcomeToSchedule", sender: self)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print("Error logging out: \(error)")
        }
        resetDefaults()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

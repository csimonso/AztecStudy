//
//  LoginViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 10/2/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase


/* Login View Controller
 *
 * Initail Login Screen.  Allows user to type in username and password, provides authentication with Firebase.
 * If user doesn't exist, they can click the register button to create a new user.
 * If user data is already stored from a previous session, this page is skipped.
 */
class LoginViewController: UIViewController {
    
    //MARK: Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: Properties
    
    let password = UserDefaults.standard.object(forKey: "password")
    let email = UserDefaults.standard.object(forKey: "email")
    
    //MARK: Action
    
    /* Register User Segue */
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "LoginToRegister", sender: self)
    }
    /* Login Button Clicked, Verify User, Set User Defaults */
    @IBAction func login(_ sender: Any) {
        //Authenticate User on Firebase
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if error == nil {
                //Set user defaults
                UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                //Segue to Welcome Page
                self.performSegue(withIdentifier: "LoginToWelcome", sender: self)
            }
            else {
                //Invalid credentials or invalid user, display an error message
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(defaultAlert)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: Initial Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set load properties
        titleLabel.layer.cornerRadius = 5
        registerButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        let strokeTextAttributes = [NSAttributedString.Key.strokeWidth : -4.0, NSAttributedString.Key.strokeColor : UIColor.black] as [NSAttributedString.Key : Any]
        titleLabel.attributedText = NSMutableAttributedString(string: "Aztec Study", attributes: strokeTextAttributes)
        //Checks if session has user data already, skips login if it does
        if email != nil && password != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LoginToWelcome", sender: self)
            }
        }
    }
}

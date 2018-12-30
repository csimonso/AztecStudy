//
//  RegisterViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 10/16/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

/* Register View Controller
 *
 * Registers a new user to Firebase.  Authenticates and sets user defaults for current session.
 */
class RegisterViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    //MARK: Action
    
    /* Segues back to login page */
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /* Submit Button Clicked.  All inputs verified they are not empty and does not exist on Firebase
     * Upon success a new user is created on Firebase and user taken to Welcome page */
    @IBAction func submit(_ sender: Any) {
        //Verifies both password fields are equal to each other, Alert if not
        if passwordTextField.text != confirmPasswordTextField.text {
            let alert = UIAlertController(title: "Password Doesn't Match", message: "Try Again", preferredStyle: .alert)
            let defaultAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(defaultAlert)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            //Authenticate new user, create new user in Firebase
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                guard let user = authResult?.user else {
                    return
                }
                //Set user defaults so user does not have to always login
                UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                //Reference Firebase
                let ref = Database.database().reference()
                let userReference = ref.child("users")
                let uid = user.uid
                let newUserReference = userReference.child(uid)
                //Set values for new user on Firebase
                newUserReference.setValue(["name": self.nameTextField.text!, "email": self.emailTextField.text!])
                //Segue to Welcome screen
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "RegisterToWelcome", sender: self)
                }
            }
        }
    }
    
    //MARK: Inital Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}

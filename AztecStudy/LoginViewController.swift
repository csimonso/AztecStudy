//
//  LoginViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 10/2/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let password = UserDefaults.standard.object(forKey: "password")
    let email = UserDefaults.standard.object(forKey: "email")
    
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "LoginToRegister", sender: self)
    }
    
    
    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if error == nil {
                UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                self.performSegue(withIdentifier: "LoginToWelcome", sender: self)
            }
            else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(defaultAlert)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.layer.cornerRadius = 5
        
        registerButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
        
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        
        let strokeTextAttributes = [NSAttributedString.Key.strokeWidth : -4.0, NSAttributedString.Key.strokeColor : UIColor.black] as [NSAttributedString.Key : Any]
        titleLabel.attributedText = NSMutableAttributedString(string: "Aztec Study", attributes: strokeTextAttributes)
        
        if email != nil && password != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LoginToWelcome", sender: self)
            }
        }
    }
}

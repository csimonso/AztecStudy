//
//  RegisterViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 10/16/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        if passwordTextField.text != confirmPasswordTextField.text {
            let alert = UIAlertController(title: "Password Doesn't Match", message: "Try Again", preferredStyle: .alert)
            let defaultAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(defaultAlert)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                guard let user = authResult?.user else {
                    return
                }
                UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                
                let ref = Database.database().reference()
                let userReference = ref.child("users")
                let uid = user.uid
                let newUserReference = userReference.child(uid)
                newUserReference.setValue(["name": self.nameTextField.text!, "email": self.emailTextField.text!])
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "RegisterToWelcome", sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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

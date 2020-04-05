 //
 //  ForgotPassViewController.swift
 //  AuthPro
 //
 //  Created by Islam on 4/5/20.
 //  Copyright © 2020 Islam. All rights reserved.
 //
 
 import UIKit
 import FirebaseAuth
 class ForgotPassViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let email = emailField.text!
        if !email.isEmpty {
            Auth.auth().sendPasswordReset(withEmail: email){(error) in
                if error == nil{
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
 }

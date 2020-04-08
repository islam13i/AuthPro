//
//  AuthViewController.swift
//  AuthPro
//
//  Created by Islam on 4/4/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import FirebaseUI
class AuthViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    var signUp: Bool = true{
        willSet{
            if newValue{
                titleLabel.text = "Регистрация"
                nameField.isHidden = false
                enterButton.setTitle("Вход", for: .normal)
            }else{
                titleLabel.text = "Вход"
                nameField.isHidden = true
                enterButton.setTitle("Регистрация", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        facebookGoogleBtnLayouts()
    }
    
    func facebookGoogleBtnLayouts() {
        let buttonFB = FBLoginButton()
        buttonFB.delegate = self
        buttonFB.permissions = ["email", "public_profile"]
        self.view.addSubview(buttonFB)
        buttonFB.translatesAutoresizingMaskIntoConstraints = false
        buttonFB.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonFB.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        buttonFB.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        buttonFB.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 20).isActive = true
        
        let buttonGoogle = GIDSignInButton()
        self.view.addSubview(buttonGoogle)
        buttonGoogle.translatesAutoresizingMaskIntoConstraints = false
        buttonGoogle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonGoogle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        buttonGoogle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        buttonGoogle.topAnchor.constraint(equalTo: buttonFB.bottomAnchor, constant: 20).isActive = true
        
        
    }
    @IBAction func switchLogin(_ sender: Any) {
        signUp = !signUp
    }
    
    @IBAction func enterAuthAction(_ sender: Any) {
        let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        if password.count < 6{
            showAlert()
            return
        }
        if signUp {
            if !name.isEmpty && !email.isEmpty && !password.isEmpty{
                Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                    if error == nil{
                        if let result = result{
                            print(result.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name" : name, "email" : email])
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }else{
                showAlert()
            }
        }else{
            if !email.isEmpty && !password.isEmpty{
                Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                    if error == nil{
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }else{
                showAlert()
            }
        }
    }
    
    func showAlert() {
        let title = "Ошибка"
        var message = "Заполните все поля"
        if passwordField.text!.count < 6{
            message = "Пароль должен быть не менее 6 символов"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}


extension AuthViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension AuthViewController: LoginButtonDelegate{
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error == nil{
            GraphRequest(graphPath: "me", parameters: ["fields:":"email,name"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get).start(completionHandler: {
                (nil, result, error) in
                if error == nil{
                    print(result as Any)
                    let credentials = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    Auth.auth().signIn(with: credentials, completion: {(result, error) in
                        if error == nil{
                            print(result?.user.uid as Any)
                            self.dismiss(animated: true, completion: nil)
                        }else{
                            print(error as Any)
                        }
                    })
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logOut")
    }
    
}


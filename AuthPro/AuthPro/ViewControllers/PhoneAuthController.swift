//
//  PhoneAuthController.swift
//  AuthPro
//
//  Created by Islam on 4/8/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import FirebaseAuth
class PhoneAuthController: UIViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        phoneNumberTextField.delegate = self
        codeTextField.delegate = self
    }
    @IBAction func phoneSignIn(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil){(result, error) in
            if error == nil{
                print(result as Any)
                guard let verificationId = result else { return }
                self.userDefault.set(verificationId, forKey: "verId")
                self.userDefault.synchronize()
            }
            print(error as Any)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
extension PhoneAuthController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.codeTextField{
            guard let code = codeTextField.text else { return }
            guard let verId = userDefault.string(forKey: "verId") else { return }
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verId, verificationCode: code)
            Auth.auth().signIn(with: credential){(result, error) in
                if let error = error{
                    print(error)
                    return
                }
               print(result?.user.uid as Any)
               
            }
        }
    }
}

//
//  PhoneAuthController.swift
//  AuthPro
//
//  Created by Islam on 4/8/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
class PhoneAuthController: UIViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    let userDefault = UserDefaults.standard
    var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        phoneNumberTextField.delegate = self
        codeTextField.delegate = self
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        let frame = CGRect(x: (xAxis - 20), y: (yAxis - 50), width: 50, height: 50)
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .pacman, color: .yellow, padding: nil)
        self.view.addSubview(activityIndicator)
    }
    
    @IBAction func phoneSignIn(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil){(result, error) in
            if error == nil{
                print(result as Any)
                guard let verificationId = result else { return }
                self.userDefault.set(verificationId, forKey: "verId")
                self.userDefault.synchronize()
                return
            }
            print(error as Any)
            self.showAlert(phone: true)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func showAlert(phone: Bool) {
        let title = "Ошибка"
        var message = "Неверный код"
        if phone{
            message = "Не удалось отправить код"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
extension PhoneAuthController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.codeTextField{
            guard let code = codeTextField.text else { return }
            guard let verId = userDefault.string(forKey: "verId") else { return }
            activityIndicator.startAnimating()
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verId, verificationCode: code)
            Auth.auth().signIn(with: credential){(result, error) in
                if let error = error{
                    self.activityIndicator.stopAnimating()
                    print(error)
                    self.showAlert(phone: false)
                    return
                }else{}
                print(result?.user.uid as Any)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

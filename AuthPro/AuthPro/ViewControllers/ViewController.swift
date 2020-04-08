//
//  ViewController.swift
//  AuthPro
//
//  Created by Islam on 4/4/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        
    }
    
}


//
//  LoginViewController.swift
//  chatApp
//
//  Created by Jae Phil on 9/2/18.
//  Copyright © 2018 jaephillseo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController : UIViewController {
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        //TODO: Login the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                print("Log in successful")
                self.performSegue(withIdentifier: "gotoChat", sender: self)
            }
        }
    }
}

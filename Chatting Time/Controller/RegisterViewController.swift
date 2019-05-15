//
//  RegisterViewController.swift
//  Chatting Time
//
//  Created by Zhi Wei Zhang on 4/18/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import AnimatedGradientView

class RegisterViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var animatedView: UIView!
    @IBOutlet var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.animationValues = [(colors: ["#2BC0E4", "#EAECC6"], .up, .axial),
                                            (colors: ["#C6FFDD", "#f7797d"], .right, .axial),
                                            (colors: ["#00d2ff", "#E5E5BE"], .down, .axial),
                                            (colors: ["#c2e59c", "#ffc3a0"], .left, .axial)]
        animatedView.addSubview(animatedGradient)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Registration Success")
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
}

//TODO: add error messages

//
//  LogInViewController.swift
//  Chatting Time
//
//  Created by Zhi Wei Zhang on 4/18/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import AnimatedGradientView

class LogInViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var animatedView: UIView!
    @IBOutlet var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.autocorrectionType = .no
        
        //Set up animation view here
        let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.animationValues = [(colors: ["#2BC0E4", "#EAECC6"], .up, .axial),
                                            (colors: ["#C6FFDD", "#f7797d"], .right, .axial),
                                            (colors: ["#00d2ff", "#E5E5BE"], .down, .axial),
                                            (colors: ["#c2e59c", "#ffc3a0"], .left, .axial)]
        animatedView.addSubview(animatedGradient)
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!._code)
                self.handleError(error!)
            }
            else {
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
        SVProgressHUD.dismiss()
    }
    
    func handleError (_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            errorMessage.text = errorCode.errorMessage
        }
    }
}

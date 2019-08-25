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
        
        errorMessage.textColor.setStroke()
        
        emailTextField.autocorrectionType = .no

        //Set up animation view here
        let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.animationValues = [(colors: ["#2BC0E4", "#EAECC6"], .up, .axial),
                                            (colors: ["#C6FFDD", "#f7797d"], .right, .axial),
                                            (colors: ["#00d2ff", "#E5E5BE"], .down, .axial),
                                            (colors: ["#c2e59c", "#ffc3a0"], .left, .axial)]
        animatedView.addSubview(animatedGradient)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        SVProgressHUD.show()
      
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
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

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user"
        case .userDisabled:
            return "Your account has been disabled"
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error, please try again"
        case .weakPassword:
            return "Password must be 6 characters or longer"
        case .wrongPassword:
            return "Your password is incorrect"
        default:
            return "Unknown error occurred"
        }
    }
}

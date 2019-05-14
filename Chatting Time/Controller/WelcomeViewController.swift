//
//  ViewController.swift
//  Chatting Time
//
//  Created by Zhi Wei Zhang on 4/15/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit
import Firebase
import AnimatedGradientView

class WelcomeViewController: UIViewController {

    @IBOutlet var animatedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.animationValues = [(colors: ["#2BC0E4", "#EAECC6"], .up, .axial),
                                            (colors: ["#C779D0", "#FF5F6D", "#DBD65C"], .right, .axial),
                                            (colors: ["#003973", "#E5E5BE"], .down, .axial),
                                            (colors: ["#c2e59c", "#FFF94C", "#FF4E50"], .left, .axial)]
        animatedView.addSubview(animatedGradient)
        // Do any additional setup after loading the view.
    }
}

//TODO: add weather

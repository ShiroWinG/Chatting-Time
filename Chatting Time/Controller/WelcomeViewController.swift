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
                                            (colors: ["#833ab4", "#fd1d1d", "#fcb045"], .right, .axial),
                                            (colors: ["#003973", "#E5E5BE"], .down, .axial),
                                            (colors: ["#1E9600", "#FFF200", "#FF0000"], .left, .axial)]
        animatedView.addSubview(animatedGradient)
        // Do any additional setup after loading the view.
    }
}

//TODO: add weather

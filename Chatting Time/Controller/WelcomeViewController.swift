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
import CoreLocation
import Alamofire
import SwiftyJSON

class WelcomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var animatedView: UIView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    var temp: Double = 0
    var city: String = ""
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Set up animation view here
        let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.animationValues = [(colors: ["#2BC0E4", "#EAECC6"], .up, .axial),
                                            (colors: ["#C6FFDD", "#f7797d"], .right, .axial),
                                            (colors: ["#00d2ff", "#E5E5BE"], .down, .axial),
                                            (colors: ["#c2e59c", "#ffc3a0"], .left, .axial)]
        animatedView.addSubview(animatedGradient)
        // Do any additional setup after loading the view.
    }
    
    //Get weather
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    //Update weather method
    func updateWeatherData(json: JSON) {
        
        if let tempResult = json["main"]["temp"].double {
            
            temp = (9/5) * (tempResult - 273) + 32
            city = json["name"].stringValue
            
            updateUIWithWeatherData()
        }
        else {
            cityLabel.text = "Weather Unavailable D:"
        }
    }
    
    //Update UI with weather data
    func updateUIWithWeatherData() {
        cityLabel.text = city
        tempLabel.text = String(Int(temp)) + "°F"
    }
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longtitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat": latitude, "lon": longtitude, "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable :["
    }
}
